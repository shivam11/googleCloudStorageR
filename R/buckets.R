#' List buckets
#'
#' @param projectId Project containing buckets to list
#' @param prefix Filter results to names begnning with this prefix
#' @param projection Properties to return. Default noAcl omits acl properties
#' @param maxResults Max number of results
#'
#' @export
gcs_list_buckets <- function(projectId,
                             prefix = "",
                             projection = c("noAcl","full"),
                             maxResults = 1000){

  projection <- match.arg(projection)

  testthat::expect_is(projectId, "character")
  testthat::expect_is(prefix, "character")
  testthat::expect_is(projection, "character")
  testthat::expect_is(maxResults, "numeric")

  lb <-
    googleAuthR::gar_api_generator("https://www.googleapis.com/storage/v1/b",
                                   "GET",
                                   pars_args = list(project=projectId,
                                                    prefix=prefix,
                                                    projection=projection))
  req <- lb()

  req$content$items

}

#' Get bucket info
#'
#' @param bucket Name of a bucket
#' @param ifMetagenerationMatch Return only if metageneration matches
#' @param ifMetagenerationNotMatch Return only if metageneration does not match
#' @param projection Properties to return. Default noAcl omits acl properties
#'
#' @return A bucket resource object
#' @export
gcs_get_bucket <- function(bucket,
                           ifMetagenerationMatch = NULL,
                           ifMetagenerationNotMatch = NULL,
                           projection = c("noAcl","full")){

  projection <- match.arg(projection)

  testthat::expect_is(bucket, "character")
  testthat::expect_is(projection, "character")

  pars_args <- list(ifMetagenerationMatch=ifMetagenerationMatch,
                    ifMetagenerationNotMatch=ifMetagenerationNotMatch,
                    projection=projection)
  pars_args <- rmNullObs(pars_args)

  bb <-
    googleAuthR::gar_api_generator("https://www.googleapis.com/storage/v1/",
                                   "GET",
                                   path_args = list(b = bucket),
                                   pars_args = pars_args)
  req <- bb()

  req$content

}

#' Create a new bucket
#'
#' @param name Globally unique name of bucket to create
#' @param projectId A valid Google project id
#' @param location Location of bucket. See details
#' @param storageClass Type of bucket
#' @param predefinedAcl Apply predefined access controls to bucket
#' @param predefinedDefaultObjectAcl Apply predefined access controls to objects
#' @param projection Properties to return. Default noAcl omits acl properties
#'
#' @details
#'   \href{https://cloud.google.com/storage/docs/bucket-locations}{See here for details on location options}
#'
#' todo: acl, cors, lifecycle, logging, versioning, website
#'
#' @export
gcs_create_bucket <-
  function(name,
           projectId,
           location = "us",
           storageClass = c("STANDARD",
                            "NEARLINE",
                            "DURABLE_REDUCED_AVAILABILITY"),
           predefinedAcl = c("authenticatedRead",
                             "private",
                             "projectPrivate",
                             "publicRead",
                             "publicReadWrite"),
           predefinedDefaultObjectAcl = c("authenticatedRead",
                                          "private",
                                          "projectPrivate",
                                          "publicRead",
                                          "publicReadWrite"),
           projection = c("noAcl","full")){

  projection    <- match.arg(projection)
  predefinedAcl <- match.arg(predefinedAcl)
  storageClass  <- match.arg(storageClass)
  predefinedDefaultObjectAcl <- match.arg(predefinedDefaultObjectAcl)

  testthat::expect_is(projectId, "character")
  testthat::expect_is(name, "character")
  testthat::expect_is(location, "character")
  testthat::expect_is(projection, "character")

  pars_args <- list(project = projectId,
                    predefinedAcl = predefinedAcl,
                    predefinedDefaultObjectAcl = predefinedDefaultObjectAcl,
                    projection = projection)
  pars_args <- rmNullObs(pars_args)

  bb <-
    googleAuthR::gar_api_generator("https://www.googleapis.com/storage/v1/b",
                                   "POST",
                                   pars_args = pars_args)

  body <- list(
    name = name,
    location = location,
    storageClass = storageClass
  )

  body <- rmNullObs(body)

  req <- bb(the_body = body)

  req$content

}
