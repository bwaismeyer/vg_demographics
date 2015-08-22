# Video Game Protagonist Demographics
This document provides a summary of project goals, intended products, and 
relevant supporting information. 

## Acronyms
*VGPD*: Project shorthand.

## Project Motives
We have heard and read much about the (lack of) diversity in video game
protagonists. This made us curious about what the actual numbers would be
if did an actual demographic breakdown of protagonist demographics. 

Secondary to this interest, we were also curious to see if there were any
relationships between protagonist characteristics, game development investment, 
and game critical and economic success.

## Project Objective
Create a database with key game and game protagonist features. Prepare a set of
blog posts and set of visualizations to share what we find. 

All code and data should be captured as an R package so that it is documented
and reproducible.

## Project Goal
We want to provide real numbers and insights to inform conversations around
who is and is not well represented as the primary playable characters in video 
games.

If possible, we also want to test claims we have anecdotally encountered
suggesting that certain protagonist features (e.g, race and gender) lack
diversity because they are associated with critical and economic success.

## Audience Definition
Project data and write-ups will be tailored to a broad audience interested
in data and video games. Data should be accessible in a broadly accessible
format (e.g., CSV or Excel files) and at least some blog posts should be
non-technical.

Project code will be tailored towards analysis-savvy people who are
comfortable with (or willing to learn) R.

## Key Tasks Product Will Support for Target Audience(s)
Our broader audience should be able to:
* Understand the premise of the study
* Observe broad trends and key takeaways
* Obtain the data in a non-specialized format

Analytically-minded folks should be able to:
* Access our finalized data as a built-in dataframe (or set of dataframes) in
    the same R package
* Access our code for gathering and cleaning data in the same R package
* Reproduce any analyses we complete or visualizations we produce either via
    documented R package functions or via clearly presented code in blog posts

## Deliverables
1. R code for gathering and cleaning data (R package)
2. Finalized data in multiple formats (R package, CSV, Excel)
3. R code for analyses and visualizations (R package and/or blog posts)
4. Non-technical summary of demographics via blog post (R markdown)
5. Non-technical summary of other key observations via blog post (R markdown)
6. At least one technical dive into analysing critical/economic success, 
    prepared as a well-structured R markdown file and knitted into a blog post

## Technical Requirements
All scraping and analysis should be completed in R or be executed by functions 
in the planned R package.

## Milestones
* Identify data targets, broad and narrow
* Identify data sources and match them to targets
* Shell and name for R package
* Plan and code strategies for gathering data
* Plan and code data cleaning
* EDA
* Plan and code demographics analysis and visualizations
* Prepare demographics blog post - non-technical but code available
* Plan and code any follow-up analyses, including success work
* Prepare technical version of follow-up post(s)
* Prepare non-technical version with key takeaways
* Finalize R package and documentation on GitHub

## Limits and Exclusions
Demographics work is the key focus. If success exploration is too difficult, it
will be shelved until the demographics work is completed (or dropped entirely).
At the moment, it appears that investment and sales data will likely be tricky
to access.