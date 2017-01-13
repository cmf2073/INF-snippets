#Dcokerfile file

FROM redmine:2.6.10

RUN apt-get update && apt-get -y install vim mysql-client


ADD database.yml /usr/src/redmine/config/database.yml
ADD configuration.yml /usr/src/redmine/config/configuration.yml

ADD plugins/claro_crm /usr/src/redmine/plugins/claro_crm
ADD plugins/redmine_agile /usr/src/redmine/plugins/redmine_agile
ADD plugins/redmine_issue_checklist /usr/src/redmine/plugins/redmine_issue_checklist 
ADD plugins/redmine_preview_attach_column /usr/src/redmine/plugins/redmine_preview_attach_column 
#ADD plugins/claro_crm-plugin-assets /usr/src/redmine/public/plugin_assets/claro_crm

#USER root # want to install some stuff so be GOD!!
#RUN apt-get update && apt-get -y install nodejs
#USER jenkins # drop back to the regular jenkins user!!

