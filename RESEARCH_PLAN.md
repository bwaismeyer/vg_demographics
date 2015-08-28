# Research Plan for VGPD
A summary of the technical planning for the project. Initially a scratchpad,
eventually a resource for top-level package documentation and technical
write-ups.

## To Do
* review Evernote and Chrome for additional sources
* review all located sources
    * verify value
    * match to data targets (and specify features they will support)
    * assess how data might be accessed and check for policies guiding access

## Data Targets
* game names
* game features: year, platform, playtime, genre, developer
* game protagonists: type, flexibility of choice, race, sex
* economic success
* critical success
* funding

## Data Sources
* playtime: http://howlongtobeat.com/
* games, reviews, systems: http://www.metacritic.com/
  - possible metacritic API: https://www.mashape.com/byroredux/metacritic
* games, systems, more: http://www.uvlist.net/
* user list of all games: http://pastebin.com/u/data_baser'
* list of game lists: https://en.wikipedia.org/wiki/Lists_of_video_games
* wikidata VG info: https://www.wikidata.org/wiki/Wikidata:WikiProject_Video_games
* list of games: http://www.mobygames.com/browse/games
* another game wiki: http://gaming.wikia.com/wiki/Encyclopedia_Gamia
* sales data: http://vgsales.wikia.com/wiki/NPD_sales_data
* investment data: might have to do this with mechanical Turk... maybe give 
    links to wiki pages and asking folks to scrape... need to investigate the 
    above sources in detail...
* global sales in millions units: http://www.vgchartz.com/gamedb/
* more charts, possibly redundant: http://www.the-magicbox.com/charts.htm
* **steam spy API**, has titles, ratings, scores (steam and metacritic), number owners, and more in one easy to call place... however it's data is always only 2 weeks old so attrition may impact results and Steam (or at least the available data) only goes back to 2009 and obviously data is platform/store limited... still, maybe an ideal place to do an initial sample: http://steamspy.com/api.php
