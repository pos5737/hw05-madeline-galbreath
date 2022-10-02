#glimpse data frame
glimpse(df11)

#create scatter plot mapping election date and percent of vote
ggplot(data = df11, mapping = aes(x = election_date, y=percent_vote)) + geom_point() + geom_jitter() + theme_bw() + xlab("Election Date") + ylab("Percent of Vote")

#create scatter plot mapping positive decentralization mentions and percent of vote
ggplot(data = df11, mapping = aes(x = decentralize, y=percent_vote)) + geom_point() + theme_bw() + xlab("Positive Decentralization Mentions") + ylab("Percent of Vote")

#calculate r of above scatter plot
summarize(df11, cor(decentralize, percent_vote, use = "pairwise.complete.obs"))

#fit above scatter plot to regression model
ggplot(df11, aes(x = decentralize, y = percent_vote)) + geom_point() + 
  geom_smooth(method = "lm", se = FALSE) + theme_bw()