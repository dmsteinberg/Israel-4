seed.k <- function(k) {
  
  aa <- c("Seed","No Seed") 
  bb <- rep(aa,k)
  cc <- order(runif(2*k))
  return(bb[cc])
  
}
bootstrap_double_ratio = function(j,unit_list,compare_to){
  
  df_24 = unit_list[[1]]
  rownames(df_24) <- NULL
  n = dim(df_24)[1]
  i = sample(1:n,n,replace=TRUE)
  rain.24 = df_24$rainfall[i]
  pred.24 = df_24[i,compare_to]
  
  is_seeded.24 = df_24$is_seeded[i]
  
  l_48 = split(unit_list[[2]],list(unit_list[[2]]$unit))
  n = length(l_48)
  i = sample(1:n,n,replace=TRUE)
  df_48 = do.call("rbind",l_48[i])
  
  rain.48 = df_48$rainfall
  pred.48 = df_48[,compare_to]
  is_seeded.48 = df_48$is_seeded
  
  all_seeded = c(is_seeded.24,is_seeded.48)
  all_rain = c(rain.24,rain.48)
  rain_ratio = mean(all_rain[all_seeded==1])/mean(all_rain[all_seeded==0])
  
  all_pred = c(pred.24,pred.48)
  pred_ratio = mean(all_pred[all_seeded==1])/mean(all_pred[all_seeded==0])
  
  return(rain_ratio/pred_ratio)
  
}
randomization_double_ratio = function(j,unit_list,compare_to){
  
  df_24 = unit_list[[1]]
  
  repeated_unit = which(df_24$unit != round(df_24$unit))
  left_out = df_24[repeated_unit,]
  
  n = nrow(df_24[-repeated_unit,])
  t1 <- ifelse(seed.list(170,7)[1:n]=="Seed",1,0)
  df_24[-repeated_unit,"is_seeded"] = t1
  left_out$is_seeded = df_24[-repeated_unit,"is_seeded"][which(df_24$unit[-repeated_unit] %in% round(df_24$unit[repeated_unit]))]
  
  df_24 = rbind(df_24[-repeated_unit,],left_out)
  
  df_48 = unit_list[[2]]
  n = dim(df_48)[1]
  t2 <- ifelse(seed.list(50,6)[1:n]=="Seed",1,0)
  df_48$is_seeded = t2
  
  df = rbind( df_24,df_48   )
  
  rain_ratio = mean(df$rainfall[df$is_seeded==1])/mean(df$rainfall[df$is_seeded==0])
  pred_ratio = mean(df[df$is_seeded==1,compare_to])/mean(df[df$is_seeded==0,compare_to])
  
  return(rain_ratio/pred_ratio)
  
  
}

data_day = read.csv("data by day.csv")

### Double Ratio compare to COSMO
rain_ratio =  mean(data_day$rainfall[data_day$is_seeded==1 ]) / mean(data_day$rainfall[data_day$is_seeded==0 ]) 
cosmo_ratio =  mean(data_day$pred_COSMO[data_day$is_seeded==1 ])    / mean(data_day$pred_COSMO[data_day$is_seeded==0 ]) 

double_ratio = rain_ratio / cosmo_ratio
double_ratio

### Randomization test compare to COSMO:

L_unit = split(data_day,list(data_day$unit_type))

double_ratio.rand = sapply(1:10000,randomization_double_ratio,unit_list=L_unit,compare_to = "pred_COSMO")
mean(double_ratio.rand >= double_ratio)

# histogram:
x11()
par(cex.main = 1.5,cex.lab = 1.5,cex.axis = 1,mar = c(5.1,5.1,5.1,2.1))
hist(double_ratio.rand,breaks=25,main="Distribution of Double Ratio\nfrom Randomization Test",axes=T,xlim=c(0.6,1.9),
     ylab="",xlab="Randomization Sample Double Ratio",col = rgb(0.2,0.3,0.7,0.5),border = rgb(0.2,0.3,0.7,0.2))
legend("topright",c("Randomization Sample",paste("Estimate = ",round(double_ratio,3),sep="")), trace=TRUE,merge=TRUE, cex = 1.2,
       pch=c(22,NA),box.col = NA,pt.bg =rgb(0.2,0.3,0.7,0.5) ,pt.cex=c(1.5,1),lwd=c(NA,2),col=c(rgb(0.2,0.3,0.7,0.2),"firebrick"))
abline(v=double_ratio,col="firebrick",lwd=2)
abline(v=double_ratio,col="firebrick",lwd=2)


### bootstrap test compare to COSMO:
double_ratio.boot = sapply(1:10000,bootstrap_double_ratio,unit_list=L_unit,compare_to = "pred_COSMO")
sd(log(double_ratio.boot),na.rm = TRUE)
exp(mean(log(double_ratio.boot),na.rm=TRUE)+ c(-1,1)*1.96*sd(log(double_ratio.boot),na.rm=TRUE))

# histogram
x11()
par(cex.main = 1.5,cex.lab = 1.5,cex.axis = 1,mar = c(5.1,5.1,5.1,2.1))
hist(double_ratio.boot,breaks=25,main="Distribution of Double Ratio\nfrom Bootstrap",axes=FALSE,
     xlim=c(0.6,1.7),ylab="",xlab="Bootstrap Sample Double Ratio",col = rgb(0.4,0.2,0.8,0.5),border = rgb(0.4,0.2,0.8,0.2))
legend("topright",c("Bootstrap Sample",paste("Estimate = ",round(double_ratio,3),sep="")),bg=NA, trace=TRUE,merge=TRUE, cex = 1.2,
       pch=c(22,NA),box.col = NA,pt.bg = rgb(0.4,0.2,0.8,0.5) ,pt.cex=c(1.5,1),lwd=c(NA,2),col=c(rgb(0.4,0.2,0.8,0.2),"firebrick"))
axis(1,at = seq(0.4,1.4,0.2))
axis(2)
abline(v=double_ratio,col="firebrick",lwd=2)



