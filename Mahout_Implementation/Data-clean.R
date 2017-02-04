library(magrittr)
library(dplyr)
library(data.table)

data_df <- data.frame(data)
head(data_df)

data_table <- data.table(data_df)

aa <- as.data.table(data_table)[, toString(movieId), by = list(userId)]
head(aa)

##### CHECKIN
checkin <- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/yelp_academic_dataset_checkin.csv")
head(checkin)
str(checkin)
summary(checkin)

##### USER
user <- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/yelp_academic_dataset_user.csv")
head(user)
str(user)

#### BUSINESS
business <- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/yelp_academic_dataset_business.csv")
head(business)
colnames(business)

sqldf('select count(distinct categories) from business')

###### TIPS
tips <- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/yelp_academic_dataset_tip.csv", quote)
head(tips,10)

####### REVIEW
file.path <- "D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/yelp_academic_dataset_review.csv"
library(data.table)
review <- fread(file.path)



nrow(review)
head(review,1)
str(review)

sqldf('select count(distinct review_id) from review')

#laddha <- select(review, user_id,review_id,votes.cool,business_id,votes.funny,stars,date,votes.useful)
#write.csv(laddha, file = "D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/laddha.csv")



# Find user_id with the # of businesses reviewed 


library(sqldf)
business_foodData <- sqldf('select distinct * from business where categories like \'%Food%\' 
                           or  categories  like \'%Restaurants%\' 
                           or categories  like \'%Lounges%\' 
                           or categories like \'%Nightlife%\' 
                           or categories like \'%Bars%\'')
str(business_foodData)



write.csv(business_foodData,'D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/All_Food_Businesses.csv')

#review_user_business <- review %>% 
#  select(user_id, business_id)

#user_business <- sqldf('select distinct * from review_user_business')
#nrow(user_business)

review_user_business <- sqldf('select distinct user_id, business_id from review')

xx <- sqldf('select r.user_id, count(r.business_id)
            from review_user_business r, business_foodData b
            where r.business_id = b.business_id
            group by r.user_id
            having count(r.business_id) > 100')
head(xx)

xx2 <- sqldf('select a.user_id, b.business_id from 
             xx a,
             business_foodData b,
             review_user_business r
             where a.user_id = r.user_id
             and b.business_id = r.business_id')
head(xx2)

write.csv(xx2,'D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/Our_Users_GreaterThan100_Businesses.csv')



#xx <- sqldf('select distinct a.user_id, count(a.business_id) 
#            from user_business a, business_foodData b
#            where a.business_id = b.business_id
##            group by a.user_id having count(a.business_id) > 100 
#          order by count(a.business_id)')

#nrow(xx)
#head(sqldf('select * from xx'))


head(xx2)

head(sqldf('select user_id, count(business_id) from xx2 group by user_id order by count(business_id)'))



######################################
str(business)
str(review)
colnames(review)[4] <- "votes_cool"
colnames(review)[6] <- "votes_funny"
colnames(review)[10] <- "votes_useful"

review2 <- sqldf('select r.* from review r, business_foodData b
                 where r.business_id = b.business_id')
nrow(review)
nrow(review2)

review_final_round <- sqldf('select r.user_id, r.business_id, avg(r.stars) as review_avg_stars
                            from review2 r, xx2 xx 
                            where r.user_id = xx.user_id 
                            group by r.user_id, r.business_id')

write.csv(review_final_round,'D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/Our_Users_GreaterThan100_Businesses_Reviews.csv')

str(review_final_round)
sqldf('select count(distinct business_id) from review')

head(sqldf('select user_id, count( business_id) from review_final group by user_id order by count(business_id)'))


head(review[1])

############# User_id, business_id, business features
str(business_foodData)

colnames(business_foodData)[32] <- "attributes_Price_Range"
colnames(business_foodData)[40] <- "attributes_Accepts_Credit_Cards"
colnames(business_foodData)[44] <- "attributes_Take_out"
colnames(business_foodData)[55] <- "attributes_Delivery"
colnames(business_foodData)[60] <- "attributes_Wheelchair_Accessible"
colnames(business_foodData)[42] <- "attributes_Good_For_lunch"
colnames(business_foodData)[68] <- "attributes_Good_For_dinner"
colnames(business_foodData)[20] <- "attributes_Good_For_brunch"
colnames(business_foodData)[33] <- "attributes_Good_For_breakfast"
colnames(business_foodData)[51] <- "attributes_Takes_Reservations"
colnames(business_foodData)[15] <- "attributes_Parking_lot"
colnames(business_foodData)[25] <- "attributes_Parking_street"
colnames(business_foodData)[34] <- "attributes_Parking_garage"
colnames(business_foodData)[43] <- "attributes_Parking_valet"
colnames(business_foodData)[76] <- "attributes_Parking_validated"
colnames(business_foodData)[93] <- "attributes_Good_For_Groups"
colnames(business_foodData)[75] <- "attributes_Good_For_kids"
colnames(business_foodData)[83] <- "attributes_Ambience_casual"
colnames(business_foodData)[96] <- "attributes_Ambience_romantic"
colnames(business_foodData)[98] <- "attributes_Ambience_upscale"
colnames(business_foodData)[13] <- "attributes_Ambience_classy"

AllusersAllBusinessAllFeatures <-
  sqldf('select r.user_id, r.business_id, a.latitude, a.longitude, a.review_count, 
        a.attributes_Price_Range, a.attributes_Accepts_Credit_Cards, a.attributes_Take_out, 
        a.attributes_Delivery, a.attributes_Wheelchair_Accessible, a.attributes_Good_For_lunch,
        a.attributes_Good_For_dinner, a.attributes_Good_For_brunch, a.attributes_Good_For_breakfast,
        a.attributes_Takes_Reservations, round(a.stars) as business_stars, a.attributes_Parking_lot, 
        a.attributes_Parking_street, a.attributes_Parking_garage, a.attributes_Parking_valet, 
        a.attributes_Parking_validated, a.attributes_Good_For_Groups, a.attributes_Good_For_kids,
        a.attributes_Ambience_casual, a.attributes_Ambience_romantic, a.attributes_Ambience_upscale, 
        a.attributes_Ambience_classy,
        r.review_avg_stars
        from business_foodData a, review_final_round r
        where a.business_id = r.business_id')

colnames(AllusersAllBusinessAllFeatures)
nrow(review_final_round)

write.csv(AllusersAllBusinessAllFeatures,'D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/OurUsers_OurBusinesses_ExtraFeatures.csv')



b <- sqldf('select distinct business_id from business_foodData')

OurUsers_NewBusinesses <-
  sqldf('select a.user_id, b.business_id from
        xx2 a, b 
        where a.business_id != b.business_id')

install.packages("sqldf")
library(sqldf)

OurUsers_NewBusinesses <-
sqldf('select a.user_id,a.business_id a_bu, b.business_id b_bu from
      b
      left join xx2 a using(business_id)')

head(sqldf('select user_id, b_bu from OurUsers_NewBusinesses where a_bu is null'))



############################################################################################
final_data_u1_train <- final_data_u1[1:947,3:16]
final_data_u1_test <- final_data_u1[948:1184,3:16]

model <- glm(avg_stars ~.,data=final_data_u1_train, na.action=na.exclude)
install.packages("e1071")

svm.model <- svm(avg_stars ~ ., data = final_data_u1_train, cost = 100, gamma = 1)
svm.pred <- predict(svm.model, final_data_u1_test[])

str(finalData)
str(review_final_round)

sqldf('select count( distinct business_id) from business_foodData')

all_features_all_users <-
  sqldf('select b.user_id, b.business_id, b.latitude, b.longitude, b.review_count,
        b.attributes_Price_Range, b.attributes_Accepts_Credit_Cards, b.attributes_Take_out,
        b.attributes_Delivery, b.attributes_Wheelchair_Accessible, b.attributes_Good_For_lunch,
        b.attributes_Good_For_dinner, b.attributes_Good_For_brunch, b.attributes_Good_For_breakfast,
        b.attributes_Takes_Reservations,
        u.review_avg_stars, u.avg_votes_funny, u.avg_votes_useful, u.avg_votes_cool,
        b.avg_stars
        from finalData b, review_final_round u
        where b.business_id = u.business_id
        and b.user_id = u.user_id')

sqldf('select count(distinct business_id) from business')

str(all_features_all_users)

write.csv(all_features_all_users, 'D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/AllFeatures_AllUsers.csv')

all_features_User1 <- sqldf('select * from all_features_all_users where user_id = \'9A2-wSoBUxlMd3LwmlGrrQ\'')
all_features_User2 <- sqldf('select * from all_features_all_users where user_id = \'Iu3Jo9ROp2IWC9FwtWOaUQ\'')
all_features_User3 <- sqldf('select * from all_features_all_users where user_id = \'ia1nTRAQEaFWv0cwADeK7g\'')
all_features_User1676 <- sqldf('select * from all_features_all_users where user_id = \'w1P9cvIVTxcLZvU5tXIhRw\'')
all_features_User200 <- sqldf('select * from all_features_all_users where user_id = \'gUr8qs00wFAk851yHMlgRQ\'')
all_features_User500 <- sqldf('select * from all_features_all_users where user_id = \'sfJP6W0E_JThj5eXLBd6pA\'')

sqldf('select count(*) from all_features_User1')

write.csv(all_features_User1, 'D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/all_features_User1.csv')
write.csv(all_features_User500, 'D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/all_features_User500.csv')


write.csv(review_final_round, 'D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/User_features_all_users.csv')


#####################3rd Dec... Trying SVM
data <- read.csv('D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV/all_features_User1_0_1.csv')

data_train <- data[1:947,4:21]
data_test <- data[948:1184,4:21]
str(data_train)
str(data_test)

svm.model <- svm(avg_stars ~ ., data = data_train, cost = 100, gamma = 1, kernel = 'linear')

svm.pred <- predict(svm.model, data_test[,-19])

table(pred = svm.pred, true = data_test[,18])

accuracy <- rmse(data_test$avg_stars, svm.pred)
accuracy

### Rpart
rpart.model <- rpart(avg_stars ~ ., data = data_train)
rpart.pred <- predict(rpart.model, data_test, type = "vector")
accuracyr <- rmse(data_test$avg_stars, rpart.pred)
accuracyr

head(data_test[,-19],1)

library(dplyr)
install.packages("tidytext")
library(tidytext)
library(sqldf)

head(review,1)

a <- select(review, review_id, business_id, stars, text)
b <- unnest_tokens(a, word, text)
c <- filter(b, !word %in% stop_words$word,
            str_detect(word, "^[a-z']+$"))

review_words <- review %>%
  select(review_id, business_id, stars, text) %>%
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word,
         str_detect(word, "^[a-z']+$"))

review_words

gcinfo(FALSE)


a <- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/Final_FilteredUsers_NewBusiness_Predictions.csv")
str(a)
sqldf('select count(distinct user_id) from a')

FilteredUsers_NewBusiness_Predictions <- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/ML_stuff/rerun/FilteredUsers_NewBusiness_Predictions.csv")
FilteredUsers_NewBusinesses_OurFeatures<- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/ML_stuff/rerun/FilteredUsers_NewBusinesses_OurFeatures.csv")
FilteredUsersAccuracy_C1 <- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/ML_stuff/rerun/FilteredUsersAccuracy_C1.csv")  

str(FilteredUsers_NewBusiness_Predictions)
str(FilteredUsers_NewBusinesses_OurFeatures)
str(FilteredUsersAccuracy_C1)
str(business_foodData)

gg <-
sqldf('select distinct a.*, b.city, b.state, b.name, b.latitude, b.longitude
      from FilteredUsers_NewBusiness_Predictions a, business_foodData b
      where a.business_id = b.business_id')

write.csv(gg, "D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/sarthak.csv")
  
gg2 <-
  sqldf('select * from gg')

head(gg2)

write.csv(gg2, "D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/UserID_City.csv")

gg3 <-
  sqldf('SELECT gg2.*
        FROM   gg2 INNER JOIN (
        SELECT user_id, GROUP_CONCAT(city) grouped_year
        FROM     gg2
        GROUP BY user_id) group_max
        ON gg2.user_id = group_max.user_id
        AND FIND_IN_SET(city, grouped_year)= 5' )

head(gg2)

sqldf('select latitude, longitude from business_foodData where city = \'LasVegas\'')

sqldf('select count(distinct user_id) from gg')

sqldf('select avg(test_accuracy) from d')

Analysis_Pred <-
  sqldf('select distinct a.user_id, business.state, a.prediction
        from FilteredUsers_NewBusiness_Predictions a, FilteredUsersAccuracy_C1 b, business
        where a.prediction in (3,4,5)
        and a.user_id = b.user_id
        and a.business_id = business.business_id
        ')

write.csv(Analysis_Pred, "D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/ML_stuff/rerun/Analysis_Pred.csv")

ss <- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/OurUsers_OurBusinesses_OurFeatures_www.csv")
sqldf("select count(distinct business_id) from ss")

aaa <- read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/aaa.csv")
sqldf("select count(distinct business_id) from aaa")



OurUsers_OurBusinesses_OurFeatures2 <- 
  read.csv("D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/OurUsers_OurBusinesses_OurFeatures2.csv")

str(OurUsers_OurBusinesses_OurFeatures2)

vv <-
sqldf('select distinct user_id,state, count(business_id) as cnt
      from OurUsers_OurBusinesses_OurFeatures2
      group by user_id, state
      order by count(business_id) desc')
head(vv)

vv2 <-
sqldf('select user_id, max(cnt) cnt2
      from vv 
      group by user_id')

vv3 <-
sqldf('select vv.user_id, vv.state, vv.cnt
      from vv, vv2
      where vv.user_id = vv2.user_id
      and vv.cnt = vv2.cnt2')

#sqldf('select count(distinct user_id) from vv3')

write.csv(vv3,'D:/GRAD_SCHOOL/Fall2016/Project_Yelp/DatasetsInCSV/DatasetsInCSV2/users_hot_state.csv' )

