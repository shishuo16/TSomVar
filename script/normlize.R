args<-commandArgs(T)
r<-read.table(args[1],sep="\t")
for(i in 1:ncol(r)){
    if(length(which(is.na(r[,i])))>0){
        mv<-mean(r[!is.na(r[,i]),i])
        sdv<-sd(r[!is.na(r[,i]),i])
        r[is.na(r[,i]),i]<-mean(r[which(r[,i]> (mv-5*sdv) & r[,i] < (mv+5*sdv) & !is.na(r[,i])),i])
    }
    mv<-mean(r[,i])
    sdv<-sd(r[,i])
    r[which(r[,i]< (mv-5*sdv)),i]<-mv-5*sdv
    r[which(r[,i]> (mv+5*sdv)),i]<-mv+5*sdv
    r[,i]<-round((r[,i]-min(r[,i]))/(max(r[,i])-min(r[,i])),3)
}
r[is.na(r)]<-0
write.table(r,args[2],sep="\t",row.names=F,col.names=F,quote=F)

