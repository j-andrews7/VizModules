#' Add Statistical Test Annotations to Plotly Figure
#' 
#' Automatically performs pairwise statistical tests (Wilcoxon rank-sum by default) 
#' between groups in a categorical X column, calculates p-values, and adds 
#' significance annotations above the plot area positioned according to group order.
#' 
#' @param fig A plotly object to annotate
#' @param df Dataframe containing the data
#' @param x Character name of the categorical grouping column (e.g., "condition")
#' @param y Character name of the numeric response column (e.g., "expression")
#' @param pairs List of length-2 vectors specifying which group pairs to test. 
#'        If NULL (default), tests all unique pairwise combinations from x column.
#' @param order Character vector specifying desired x-axis group order. 
#'        If NULL (default), uses natural order of unique values in x.
#' @param type_test Character; currently only "wilcox" (Mann-Whitney U test) supported
#' @param type_correction Character; reserved for future multiple testing correction
#' @param cutoff_pvalue Numeric (0.05); currently unused but reserved for filtering
#' 
#' @return Annotated plotly figure with p-value labels positioned above bars/groups
#' @importFrom ggpubr compare_means
#' @details 
#' Performs Wilcoxon rank-sum tests between all specified pairs (or all pairs if 
#' `pairs = NULL`). P-value annotations appear above the plot in red text, 
#' horizontally centered between the tested group pair, vertically spaced by 10% 
#' of y-range increments. Y-axis automatically expands to accommodate annotations.
#' 
#' Group order validation ensures all specified `order` elements exist in x column 
#' and match its unique length. Early return with message on validation failure.
#' 
#' Designed for bioinformatics visualization workflows - e.g., gene expression 
#' across conditions, cell type comparisons.
#' 
#' @author Jacob
#' 
#' @export



plot_stats <- function(fig, df, x, y, 
        pairs = NULL,
        order = NULL, 
        type_test = "wilcox.test", 
        type_correction = NULL,
        p_adjustment = "holm",
        # subcategory = NULL,  #Potential Future input 
        cutoff_pvalue = 0.05,
        symbol = TRUE,
        group_by = NULL
        ){
    
    
    # Create all combinations if paurs is NULL. combn(lst, 2, simplify = FALSE)

    all_x <- unique(df[[x]])

    y_plot <- y
    
    #SETTING ORDER
    if (is.null(order)){
        order <- all_x
    } else {
        for (element in order){
            if (!(element %in% all_x)){
                return(fig)
                message("order is incorrect. Order not in X column")
            }
        }
        if (length(unique(order)) != length(all_x)){
            return(fig)
            message("Expected all items in X ")
        }
    }

    #Calculating the MIN and MAX values of Y 

    v_min <- min(df[[y_plot]])
    v_max <- max(df[[y_plot]])
    v_unit <- (v_max - v_min) * 0.1 # Sets the spacing between each pValue annotation

    #Find Grouping: 
    #COULD ADD GROUPING LOGIC HERE FOR SUBCATEGORIES
    all_group = all_x 


    #Creating Pairs combinations if pairs is NULL
    if (is.null(pairs)){
        pairs <- combn(all_group, 2, simplify = FALSE)
    } 

    
    pValues <- list()
    index <- list()
    #Generating X indexing and P values
    for (pair in pairs){
        subset_data <- df[df[[x]] %in% pair, ]

        test <- compare_means(formula = reformulate(x, response = y), data = subset_data, method = type_test, paired = TRUE, p.adjust.methods = p_adjustment, group.by = group_by)
        pValue <- round(test$p.adj[1], 3)

        
        if (symbol){
            if (pValue <= cutoff_pvalue) {
                subList <- c(test$p.signif)
                subIndex <- c()
                for (p in pair){
                    index_num <- match(p, order)
                    subIndex <- c(subIndex, index_num)
                }
                pValues[[length(pValues) + 1]] <- subList
                index[[length(index) + 1]] <- subIndex
            }
            } else {
                subList <- c(round(test$p.adj[1], 3))
                subIndex <- c()
                for (p in pair){
                    index_num <- match(p, order)
                    subIndex <- c(subIndex, index_num)
                }
                pValues[[length(pValues) + 1]] <- subList
                index[[length(index) + 1]] <- subIndex
          
            }
    }

    #Ordering Pvalues vector list based on gap between x0 and x1 positions
    # Extract 1st and 3rd as numeric vectors
    
    gaps <- c()
  
    for (i in seq_along(index)){
        v <- index[[i]]
        gap <- as.numeric(v[2]) - as.numeric(v[1])
        gaps <- c(gaps, gap)
    }
    
    ord_idx <- order(gaps, decreasing = FALSE)
    pValues <- pValues[ord_idx]
    index <- index[ord_idx]
    #Creating annotation lists

    annots <- list()
    shapes <- list()

    y_val_incre <- v_max + v_unit 
    base <- v_max + v_unit


    annots <- list()
    shapes <- list()

    for (i in seq_along(pValues)) {
        x0 <- as.numeric(index[[i]][1])
        x1 <- as.numeric(index[[i]][2])
        x_val <- (x0 + x1) * 0.5
        gap <- abs(x1 - x0)
        
        if (gap == 1) {

            y_val <- base

        } else {
            y_val_incre <- y_val_incre + v_unit 
            y_val <- y_val_incre
        }

        
        # Add annot/shape
        subAnno <- list(text = pValues[[i]][1], x = x_val, y = y_val, 
                        showarrow = FALSE, font = list(size = 16, color = "black"))
        annots[[length(annots) + 1]] <- subAnno 
        
        subShape <- list(type = "line", line = list(color = "black", width = 10),
                        xref = "x", yref = "y", 
                        x0 = x0 - 0.2, x1 = x1 + 0.2, 
                        y0 = y_val * 0.98, y1 = y_val * 0.98)
        shapes[[length(shapes) + 1]] <- subShape
    }
    y_max <- y_val + v_unit

    
  
    fig <- fig %>% layout(annotations = annots, shapes = shapes, yaxis = list(range = c(v_min, y_max)))
    object <- list("fig" = fig, "ymax" = y_max, "shapes" = shapes) # Decided to export y_max to apply to the layout within the server code - Layout wasnt being updated properly. 
    return(object)

}