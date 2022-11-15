
nextflow.enable.dsl = 2



/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    PARAMETERS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

file_ch = Channel.fromPath( params.inputfile )
	.splitCsv()

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { RUN } from './modules/local/run'


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    HELP 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

def helpMessage() {
    log.info """
          Usage:
          The typical command for running the pipeline is as follows:
          runthis --inputfile inputfile.csv [--outdir results] [-c user.config]

          Arguments:
           --inputfile                    CSV file with list of sampleD and commands [./inputfile.csv]
           -c file                        Add this configuration file. Used to specify which modules to load
           --outdir                       Output director [./results]
           --help                         This usage statement

          Other useful nextflow arguments:
           -resume                        Execute the script using the cached results, useful to continue executions that was stopped by an error [False]
           -with-tower                    Monitor workflow execution with Seqera Tower service [False]
           -ansi-log                      Enable/disable ANSI console logging [True]
           -N, -with-notification         Send a notification email on workflow completion to the specified recipients [False]

          Example inputfile:
           1,Rscript myscript.R --param bar
           2,Rscript myscript.R --param bar

          Example config file:
           process {

             // Add here the modules you need to run your specific commands
             // For the modules to work, you need to source your .bashrc first, then we suggest to purge all the modules
             // Check that the modules added here are loaded correctly before running the pipeline

             beforeScript = 'source $HOME/.bashrc; module purge; module load r/recommended'
             module = 'samtools:blic-modules:bwameth'

             // Defaults for all processes
             // Modify if needed

             cpus = 1
             memory = '7.GB'
             time = '4.h'

           }
           """
}

if (params.help){
    helpMessage()
    exit 0
}


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    HEADER
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


// Header 
println "========================================================"
println "    N E X T F L O W   R U N T H I S   P I P E L I N E   "
println "========================================================"
println "['Pipeline Name']     = nf/runthis"
println "['Pipeline Version']  = $workflow.manifest.version"
println "['Inputfile']         = $params.inputfile"
println "['Outdir']            = $params.outdir"
println "['Working dir']       = $workflow.workDir"
println "['Current user']      = $USER"
println "========================================================"



/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN ALL WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow{ 
    RUN(file_ch) 
} 


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow.onComplete {                
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}


workflow.onError = {
    println "Oops... Pipeline execution stopped with the following message: ${workflow.errorMessage}"
}
