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
#' 
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
        type_test = "wilcox", 
        type_correction = NULL,
        # subcategory = NULL,  #Potential Future input 
        cutoff_pvalue = 0.05
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
    #Generating X indexing and P values
    if (type_test == "wilcox"){
        for (pair in pairs){
            subset_data <- df[df[[x]] %in% pair, ]
            test <- wilcox.test(reformulate(x, y), data = subset_data)


            pValue <- round(test$p.value, 3)
            subList <- c(pValue)
            for (p in pair){
                index <- match(p, order)
                subList <- c(subList, index)
            }
            pValues[[length(pValues) + 1]] <- subList
        }
    }
  
    #Creating annotation lists
    y_val <- v_max
    annots <- list()
    shapes <- list()
    for (item in pValues){
        x_val <- (item[2] + item[3]) * 0.5
        y_val <- y_val + v_unit

        subAnno <- list(text = item[1], x = x_val, y = y_val, showarrow = FALSE, font = list(size = 16, color = "red"))
        annots[[length(annots) + 1]] <- subAnno 
      
        subShape <- list(type = "line", line = list(color = "black", width = 10),
                            xref = "x", yref = "y", x0 = item[2] - 0.2 , x1 = item[3] + 0.2, y0 = y_val * 0.98, y1= y_val *0.98)
        shapes[[length(shapes) + 1]] <- subShape
    }
    y_max <- y_val + v_unit
    
  
    fig <- fig %>% layout(annotations = annots, shapes = shapes, yaxis = list(range = c(v_min, y_max)))
    object <- list("fig" = fig, "ymax" = y_max, "shapes" = shapes) # Decided to export y_max to apply to the layout within the server code - Layout wasnt being updated properly. 
    return(object)

    }