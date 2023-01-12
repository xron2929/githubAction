#!/bin/bash
PROJECT_NAME="github_action"
JAR_PATH="/home/ubuntu/github_action/build/libs/*.jar"
DEPLOY_PATH=/home/ubuntu/$PROJECT_NAME/
DEPLOY_LOG_PATH="/home/ubuntu/$PROJECT_NAME/deploy.log"
DEPLOY_ERR_LOG_PATH="/home/ubuntu/$PROJECT_NAME/deploy_err.log"
APPLICATION_LOG_PATH="/home/ubuntu/$PROJECT_NAME/application.log"
echo "===== 이전 프로세스 죽이기 시작 : $(date +%c) =====" >> $DEPLOY_LOG_PATH
BUILD_JAR=$(ls $JAR_PATH)
echo "> BUILD_JAR 목록1 $BUILD_JAR and" >> $DEPLOY_LOG_PATH
JAR_NAME=$(basename $BUILD_JAR)
echo "> BUILD_JAR 목록2 $BUILD_JAR and" >> $DEPLOY_LOG_PATH
echo echo "> JAR_NAME 목록1 $JAR_NAME and" >> $DEPLOY_LOG_PATH

echo "> build 파일명: $JAR_NAME" >> $DEPLOY_LOG_PATH
echo "> build 파일 복사" >> $DEPLOY_LOG_PATH
cp $BUILD_JAR $DEPLOY_PATH
echo "> BUILD_JAR 목록3 $BUILD_JAR and" >> $DEPLOY_LOG_PATH
echo "> 현재 동작중인 어플리케이션 pid 체크" >> $DEPLOY_LOG_PATH
CURRENT_PID=$(pgrep -f $JAR_NAME)
echo "> BUILD_JAR 목록4 $BUILD_JAR" >> $DEPLOY_LOG_PATH
if [ -z $CURRENT_PID ]
then
  echo "> 현재 동작중인 어플리케이션 존재 X" >> $DEPLOY_LOG_PATH
else
  echo "> 현재 동작중인 어플리케이션 존재 O" >> $DEPLOY_LOG_PATH
  echo "> 현재 동작중인 어플리케이션 강제 종료 진행" >> $DEPLOY_LOG_PATH
  echo "> kill -9 $CURRENT_PID" >> $DEPLOY_LOG_PATH
  kill -9 $CURRENT_PID
fi
echo "===== 배포 시작 : $(date +%c) =====" >> $DEPLOY_LOG_PATH
DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME
echo "> DEPLOY_JAR 배포" >> $DEPLOY_LOG_PATH
nohup java -jar $DEPLOY_JAR >> $APPLICATION_LOG_PATH 2> $DEPLOY_ERR_LOG_PATH &

sleep 3

echo "> 배포 종료 : $(date +%c)" >> $DEPLOY_LOG_PATH