# import library 
library(dplyr)
library(ggplot2)
# read file covid19.csv 

getwd()

data <- read.csv('dataset/covid19.csv')

# check dataset 
# colnames(data)
# nrow(data)
# ncol(data)

# head(data) 
tail(data)
# str(data) 
# summary(data)

# Filter and select relevant data using dplyr functions
# covid_selected <- data %>%
#   select(Date, Country_Region, recovered, death, total_tested)

# head(covid_selected)

# # data %>% select(starts_with("Conf"))
# # data %>% select(ends_with("ed"))

# # death > 200000
# covid_filtered <- data %>% filter(death > 200000)
# covid_filtered

# # covid_united_states 
# covid_united_states <- data %>% filter(death > 200000) %>% select(Date, Country_Region, death) %>% arrange(desc(death))
# head(covid_united_states)

# Aggregate data by country and calculate summary statistics

# Total testing --> death, recovered, confirmed
# covid_by_country <- data %>%
#   group_by(Country_Region) %>%
#   summarise(
#     total_confirmed = sum(total_tested, na.rm = TRUE),
#     total_deaths    = sum(death, na.rm = TRUE),
#     total_recovered = sum(recovered, na.rm = TRUE)
#   )

# # covid_by_country

# # mean, max, min 
# covid_stats <- data %>%
#   group_by(Country_Region) %>%
#   summarise(
#     avg_confirmed = mean(total_tested, na.rm = TRUE),
#     max_confirmed = max(total_tested, na.rm = TRUE),
#     min_confirmed = min(total_tested, na.rm = TRUE),
#     days_recorded = n()
#   )


# # case fatality rate 
# covid_summary <- data %>%
#   group_by(Country_Region) %>%
#   summarise(
#     total_confirmed = sum(total_tested, na.rm = TRUE),
#     total_deaths    = sum(death, na.rm = TRUE)
#   ) %>%
#   mutate(
#     fatality_rate = total_deaths / total_confirmed
#   )

# covid_summary

# plot for top country by posituve case ratio 
results <- data %>% group_by(Country_Region)  %>% summarize(
  total_tests  = sum(total_tested, na.rm = TRUE), 
  total_positives = sum(positive, na.rm = TRUE)
) %>% mutate (
  positive_ratio = total_positives / total_tests 
)

top10 <- results %>% arrange(desc(positive_ratio)) %>% slice(1:10)


ggplot(top10, aes(x = reorder(Country_Region, positive_ratio),
                  y = positive_ratio)) +
  geom_col(fill = "tomato") +
  coord_flip() +
  labs(
    title = "Top 10 Countries by Positive Case Ratio",
    x = "Country",
    y = "Positive Ratio"
  )

ggsave("plots/top10_positive_ratio.png", width = 8, height = 5)

ggplot(results, aes(x = total_tests, y = positive_ratio)) +
  geom_point(alpha = 0.6) +
  labs(
    title = "Total Tests vs Positive Case Ratio",
    x = "Total Tests",
    y = "Positive Case Ratio"
  )

ggsave("plots/scatter_top10_positive_ratio.png", width = 8, height = 5)