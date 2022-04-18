args<-commandArgs(T)
r<-read.table(args[1],sep="\t",head=T)
for(i in 1:ncol(r)){
    if(length(which(is.na(r[,i])))>0){
        mv<-mean(r[!is.na(r[,i]),i])
        sdv<-sd(r[!is.na(r[,i]),i])
        r[is.na(r[,i]),i]<-mean(r[which(r[,i]> (mv-5*sdv) & r[,i] < (mv+5*sdv) & !is.na(r[,i])),i])
    }
}
write.table(r,args[2],sep="\t",row.names=F,quote=F)
