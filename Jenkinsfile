pipeline {
    agent any
    stages {
        stage('Parse config') {
            steps {
                script {
                    configData = readYaml file: env.CONFIG_FILE

                    env.ROOT_TEX_PATH = configData.root_tex_path ?: 'tex'
                    env.SECTIONS_PATH = configData.sections_path ?: 'sections'
                    env.PREAMBLE_CUSTOMIZATION_FILE = configData.preamble_customization_file ?: 'preamble-customization.tex'
                    env.ADDITIONAL_INPUTS = configData.additional_inputs ?: ["title", "abstract", "table_of_contents", "glossary"]
                }
            }
        }
        stage('Preapre build folder') {
            steps {
                sh 'mkdir build-result'
            }
        }
        stage('Build') {
            agent {
                docker {
                    image 'haritowa/bsuir-latex-build-system:0.0.1'
                    args '-v ${WORKSPACE}/build-result:/build-result'
                }
            }
            steps {
                sh 'cp -r /container/* .'
                sh 'cp -r stp/* $ROOT_TEX_PATH/'
                sh './latex-project-builder -r ${ROOT_TEX_PATH} -s ${SECTIONS_PATH} -p ${PREAMBLE_CUSTOMIZATION_FILE}'

                // Stupid jenkins bug with dir inside docker container
                sh 'cd tex && $PDFLATEX $MAINTEX'

                // TODO: Add makeglossaries to preamble
                // sh 'cd tex && makeglossaries $MAINTEX'

                // TODO: Add support for bibtex
                // sh 'cd tex && bibtex $MAINTEX'

                sh '''cd tex && $PDFLATEX $MAINTEX > /dev/null
                    $PDFLATEX $MAINTEX'''

                sh 'cp tex/$MAINTEX.pdf /build-result/$RESULT_PDF_NAME'
            }
        }
        stage('Cleanup') {
            steps {
                sh 'find -E tex/ -maxdepth 1 -type f ! -regex ".*\\.(tex|log|blg|bib|cls|sty|bst|clo|asm|gitignore)" -exec rm -f {} \\; ;'
            }
        }
        stage('Release') {
            environment {
                newBuild = "${BRANCH_NAME}(${BUILD_NUMBER}).pdf"
                dropboxFolder = "build/${BRANCH_NAME}"
                dropboxURL = "$DROPBOX_ROOT_URL/${dropboxFolder}"
            }
            steps {
                archiveArtifacts env.RESULT_PDF_NAME
                sh 'cp $RESULT_PDF_NAME ${newBuild}'
                
                script {
                    if (env.DROPBOX_CONFIG_NAME != null) {
                        dropbox(sourceFiles: newBuild, remoteDirectory: dropboxFolder, configName: env.DROPBOX_CONFIG_NAME)
                    } else {
                        echo "Dropbox config name is not specified, skip upload step"
                    }
                }
            }
        }
    }
    environment {
        CONFIG_FILE = 'bsuir_build_config.yml'
        MAINTEX = 'compiled'
        PDFLATEX = 'pdflatex -interaction=nonstopmode -shell-escape -file-line-error'
        RESULT_PDF_NAME = 'result.pdf'

        // Insert yor config name to enable dropbox upload
        // DROPBOX_CONFIG_NAME = 'practice'
        DROPBOX_ROOT_URL = 'https://www.dropbox.com/home/Practice/note'
    }
}