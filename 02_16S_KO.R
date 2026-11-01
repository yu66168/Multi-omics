# AJGL analysis module. Keep this file in the extracted package root.
# Run: Rscript 02_16S_KO.R [frozen|new]
if(.Platform$OS.type=='windows')for(loc in c('English_United States.utf8','Chinese (Simplified)_China.utf8')){
 ok<-suppressWarnings(tryCatch(Sys.setlocale('LC_CTYPE',loc),error=function(e)''));if(nzchar(ok))break
}
argv<-commandArgs(trailingOnly=FALSE)
script<-sub('^--file=','',argv[grepl('^--file=',argv)][1])
if(is.na(script))stop('Use Rscript with this file, or set the working directory and use the instructions in README_中文.md.')
project<-normalizePath(dirname(script),winslash='/',mustWork=TRUE)
extra<-Sys.getenv('AJGL_R_LIBRARY');if(nzchar(extra)).libPaths(c(extra,.libPaths()))
args<-commandArgs(trailingOnly=TRUE);profile<-if(length(args))args[1]else'frozen'
if(!profile%in%c('frozen','new'))stop('Profile must be frozen or new')
source(file.path(project,'config.R'));source(file.path(project,'R/common.R'))
result_dir<-file.path(project,'results','16S_KO',profile);dir.create(result_dir,recursive=TRUE,showWarnings=FALSE)
if(profile=='new')asv_input<-'data/current/ASV_original.csv'
source(file.path(project,'R/03_microbiome.R'))
if(profile=='frozen')source(file.path(project,'R/04_KO.R'))
# KO predictions are archived inputs, not inferred anew from an ASV count table.
capture.output(sessionInfo(),file=file.path(result_dir,'sessionInfo.txt'))
cat('Completed ->',result_dir,'\n')
