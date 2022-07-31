install.packages('rsconnect', dependencies = TRUE)
library(rsconnect)


rsconnect::setAccountInfo(name="<ACCOUNT>", token="<TOKEN>", secret="<SECRET>")




rsconnect::setAccountInfo(name='cococatty', token='0DD0F13A53887A845F0C9E96CD014D38', secret='JfN6yWxyvqxaYe4JcDttvM9tDXo4Sy1uVwQNcB/U')

###########     DEPLOY
library(rsconnect)
deployApp()
