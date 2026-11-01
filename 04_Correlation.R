# AJGL analysis module. Keep this file in the extracted package root.
# Run: Rscript 04_Correlation.R [frozen|new]
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
result_dir<-file.path(project,'results','correlation',profile);dir.create(result_dir,recursive=TRUE,showWarnings=FALSE)
if(profile=='new')stop('New cross-omics analysis requires a reviewed cross-assay animal-ID map and final feature lists. Do not infer biological identity from matching digits.')
source(file.path(project,'R/05_correlations.R'))
# |r|>0.6 and raw P<0.05 select exploratory edges. BH covers all tested pairs.
capture.output(sessionInfo(),file=file.path(result_dir,'sessionInfo.txt'))
cat('Completed ->',result_dir,'\n')
