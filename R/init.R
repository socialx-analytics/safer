#' Initialize SAFER Database
#'
#' This function initializes a SQLite database for the SAFER process.
#' It connects to a database, modifies the input dataframe by adding an index and a label column,
#' and then writes the data into a specified table.
#'
#' @param df Dataframe to be stored in the database.
#' @param db_name Name of the SQLite database file. Default is "safer.sqlite".
#' @param table_name Name of the table within the database. Default is "safer_table".
#' @param append Logical; if TRUE, data will be appended to the existing table. Default is FALSE.
#' @param overwrite Logical; if TRUE, existing table will be overwritten. Default is FALSE.
#' @return None
#' @export
#' @examples
#' \dontrun{
#' init(df = your_dataframe)
#' }
init <- function(df, db_name = "safer.sqlite", table_name = "safer_table", append = FALSE, overwrite = FALSE) {

  # Connect to the SQLite database
  con <- DBI::dbConnect(RSQLite::SQLite(), dbname = db_name)

  # Modify dataframe: add 'label' column (initialized with NA) and 'index' column
  df <- df |>
    dplyr::mutate(label = NA) |>
    tibble::rowid_to_column("id")

  # Write the modified dataframe to the database table
  DBI::dbWriteTable(con, table_name, df, append = append, overwrite = overwrite)

  # Disconnect from the database
  DBI::dbDisconnect(con)
}
