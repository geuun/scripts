#!/bin/bash





if cat (crontab -l) | grep "nohup */10 * * * * bash ./RUN_CD >> ./deploy.log 2>&1 &" ;
then
    echo "Crontab already set !"
    echo "So Stop Crontab Setting :)"
    exit 0
fi

# 
touch ./deploy.log

# 10분마다 실행하는 Crontab을 새로 등록 및 로그 저장
# ex) cat <(crontab -l) <(echo "nohup 0,30 * * * * bash ./deploy.sh >> ./deploy.log 2>&1 &") | crontab
cat <(crontab -l) <(echo "nohup */10 * * * * bash ./RUN_CD >> ./deploy.log 2>&1 &") | crontab