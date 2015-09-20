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
* titles, ratings (steam/metacritic), number of owners, and more: steam spy API
    * however it's data is always only 2 weeks old so attrition may impact 
    results and Steam (or at least the available data) only goes back to 2009 
    and obviously data is platform/store limited... still, maybe an ideal place 
    to do an initial sample: http://steamspy.com/api.php

## Data Plan
There is only one resource that combines most of what we are looking for 
together in advance: Steam Spy API. The data is also regularly updated and is 
collected from a well controlled environment (the digital Steam platform) that 
probably promotes reliable and (in the context of Valve's business needs) valid 
data.

The downsides to Steam Spy are that it is based on a limited sample of all
possible games - restricted by console, age, and Valve's business objectives -
and it is based only on the past two weeks worth of Valve's data and 
relies on Steam Spy author algorithms for many values (more here:
http://steamspy.com/about).

The limited game sample is problematic for several distinct reasons. First,
we cannot do the exciting thing of observing protagonist demographics over
the lifespan of gaming history. Second, it is unclear if it is appropriate to
treat the sample of games and their protagonists as representative of all
games across all platforms as we can only observe games that were created for
or ported to PC/Mac/Linux platforms. Third, we will be inferring game 
economic and critical success for the population that uses Steam and it is
unclear if this population is representative of gamers across all gaming
platforms and gamer generations.

The limited data scope is problematic in that user and game attrition from
Steam (users leaving the service or games being removed) may impact the
games and data we observe.

Still, as long as we keep the above limitations in mind, Steam Spy data
seems like an excellent starting point. It covers a hearty window of 
time, covers a large genre of games, the games covered are relatively 
modern (and thus likely to have good Wiki data), the games are accessible, 
and ratings and sales are observed for a large base of users. We can't be
sure that this isn't a biased sample of users (e.g., perhaps the male/female
ratio of Steam users differs from other consoles or perhaps males are
more likely to rate games), but it is likely representative enough to give 
us a sense of general interest in Steam games.

Thus, the core of our database will be Steam Spy database. This will cover
the following data targets:

* game names (as named on Steam)
* economic success (number of owners)

This doesn't quite cover:

* data relevant to critical success appears to be available on the site but
    not via the API... so, not including that... though maybe could contrast
    owners versus people who have played the game (better if could factor
    in how long game was played)...
* developer, genre, and year also seem to float around, but not available
    via API...
* maybe could use tags for some protagonist-relevant data, but not available
    via API...
* could maybe scrape the scrape the site itself to get some of this 
    information, but probably better to check with the Steam Spy 
    developer first to see if automating this scraping would go against
    how he wants his site used... worst case, could do this manually...

This fails to cover:
* game features: playtime, platform (can assume PC but won't know all consoles)
* game protagonists: type, flexibility of choice, race, sex
* funding