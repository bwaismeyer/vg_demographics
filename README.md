# vg_demographics
Exploring vg demographics and related data.

# data targets
* game names
* game features: year, platform, playtime, genre, developer
* game protagonists: type, flexibility of choice, race, sex
* economic success
* critical success
* funding

# data sources
* playtime: http://howlongtobeat.com/
* games, reviews, systems: http://www.metacritic.com/
* games, systems, more: http://www.uvlist.net/
* user list of all games: http://pastebin.com/u/data_baser'
* list of game lists: https://en.wikipedia.org/wiki/Lists_of_video_games
* list of games: http://www.mobygames.com/browse/games
* another game wiki: http://gaming.wikia.com/wiki/Encyclopedia_Gamia
* sales data: http://vgsales.wikia.com/wiki/NPD_sales_data
* investment data: might have to do this with mechanical Turk... maybe give 
    links to wiki pages and asking folks to scrape... need to investigate the 
    above sources in detail...
* global sales in millions units: http://www.vgchartz.com/gamedb/

# to do
* review Evernote and Chrome for additional sources
* review all located sources: features covered, access strategies

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
who is and is not well represented in video games.

If possible, we also want to test claims we have anecdotally encountered
suggesting that certain protagonist features (e.g, race and gender) lack
diversity because they are associated with critical and economic success.

## Audience Definition
Project code will be tailored towards analysis-savvy people who are
comfortable with (or willing to learn) R.

Project data and write-ups will be tailored to a broad audience interested
in data and video games.

## Key Tasks Product Will Support for Target Audience(s)
*Only really useful when the project is product focused. In this case, you need 
to specify the most important one to five tasks the product will support. The 
product should be designed around these tasks and product testing should test 
the target audience ability to complete these tasks. Do not try to design a 
single product for more than five tasks - more tasks than this suggests you 
either need multiple products or you need to develop and test your product in 
phases.*

Wombats should be able to:
* Learn about the wombat welfare process - where it begins and keys stages
participants proceed through.
* Get a rough sense of how many wombats are involved at different stages
of the wombat welfare process.
* Determine how many wombats are currently in out-of-hole care.
* Determine common outcomes for out-of-hole care.
* Assess how out-of-hole placement and outcomes have changed over time 
(current should allow for coverage of the last 12 years).

## Deliverables
*List of the concrete components that satisfy the objective.*

1. Standardized application structure and documentation
2. Necessary database updating/organizing complete
3. Data creation/flow complete and update schedule set
4. Integration of app into POC's current data tool collection.
5. Transition to advertising, testing, revision.

## Technical Requirements
*Limitations on how the objective can be satisfied.*

Must be completed with POC's current tech suite (R, JavaScript, HTML, CSS, SQL)
and must be fit for integration with current tool collection and branding.

## Milestones
*Major steps in the process with soft/hard deadlines.*

* April 1: Stakeholder agreement on project scope (objective, goal, etc.).
* April 15: Mock-ups and tech strategy complete.
* April 30: Prototype implemented. Stakeholder review.

## Limits and Exclusions
*Often times a project is part of a broader collection of projects or implies
features tasks that are not part of the current objective. Here is where such
confusions can be clarified.*

This project does not include advertising or full-scale usability testing in
its scope. These will likely need to be tackled after the project given
available resources/personnel.