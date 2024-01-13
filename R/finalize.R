#' Finalize and Export SAFER Database Table to CSV
#'
#' This function reads the entire table from a specified SQLite database and exports it as a CSV file.
#' The resulting CSV file contains all the data from the database table, including any processed rows.
#'
#' @param db_name Name of the SQLite database file. Default is "safer.sqlite".
#' @param table_name Name of the table within the database. Default is "safer_table".
#' @param output Filename for the exported CSV file. Default is "result.csv".
#' @return None
#' @export
#' @examples
#' \dontrun{
#' finalize(db_name = "safer.sqlite", table_name = "safer_table", output = "result.csv")
#' }
finalize <- function(db_name = "safer.sqlite", table_name = "safer_table", output = "result.csv") {

  # Connect to the SQLite database
  con <- DBI::dbConnect(RSQLite::SQLite(), dbname = db_name)

  # Read the entire table from the database
  df <- DBI::dbReadTable(con, table_name)

  # Export the dataframe to a CSV file
  readr::write_csv(df, output)

  # Disconnect from the database
  DBI::dbDisconnect(con)
}
