Mahout Recommendation – Grouplens

I first downloaded the grouplens dataset from the web.
Then, cleaned the ratings.csv so that it contains only userId and movieId which signifies that which user likes which movies. I saved this file as ratings.txt
I also created a users.txt which contains the userId for the user for whom the recommendation needs to be created. I ran the recommendation for userId 1.
I then ran the algorithm in all the three modes – Standalone, Pseudo and Fully Distributed mode.
According to my observation, the algorithm ran the fastest in Fully distributed mode.
