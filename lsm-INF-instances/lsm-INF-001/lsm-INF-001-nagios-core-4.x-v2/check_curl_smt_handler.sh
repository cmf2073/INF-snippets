#!/bin/bash

SMT_HANDLER_STATE=$(curl -sssssss -X POST -H "Cache-Control: no-cache" -H "Content-Type: text/xml" -d '<?xml version="1.0" encoding="utf-8" ?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken><wsse:Username>PushTravel_Mx</wsse:Username><wsse:Password>EarNxuMifJ310+eNYHlZyWPTEek=</wsse:Password><wsse:Nonce>16047E6FC52E3B5DDAC812EB85830EF3</wsse:Nonce><wsu:Created xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">2016-07-27T21:39:18Z</wsu:Created></wsse:UsernameToken></wsse:Security><tns:NotifySOAPHeader xmlns:tns="http://www.huawei.com.cn/schema/common/v2_1"><tns:AppId>0019982000014770</tns:AppId><tns:TransId>504021505351607271639187172002</tns:TransId></tns:NotifySOAPHeader></soapenv:Header><soapenv:Body><ns1:syncOrderRelationship xmlns:ns1="http://www.csapi.org/schema/parlayx/syncsubscription/v1_0/local"><ns1:userID><ID>521000000009</ID><type>0</type></ns1:userID><ns1:spID>PA00001998</ns1:spID><ns1:productID>MDSP2000015940</ns1:productID><ns1:serviceID>0019982000014770</ns1:serviceID><ns1:updateType>3</ns1:updateType><ns1:creatTime>20160727213918</ns1:creatTime><ns1:effectiveTime>20160509202343</ns1:effectiveTime><ns1:expireTime>20370101000000</ns1:expireTime><ns1:rentResult>3</ns1:rentResult><ns1:extensionInfo><NamedParameters><key>orderKey</key><value>999000000308567846</value></NamedParameters><NamedParameters><key>channelID</key><value>000</value></NamedParameters><NamedParameters><key>operatorID</key><value>5201</value></NamedParameters><NamedParameters><key>accessCode</key><value>528687</value></NamedParameters><NamedParameters><key>chargeMode</key><value>19</value></NamedParameters><NamedParameters><key>MDSPSUBEXPMODE</key><value>1</value></NamedParameters><NamedParameters><key>objectType</key><value>1</value></NamedParameters><NamedParameters><key>cycleEndTime</key><value>20160803050000</value></NamedParameters><NamedParameters><key>durationOfGracePeriod</key><value>56</value></NamedParameters><NamedParameters><key>serviceAvailability</key><value>1</value></NamedParameters><NamedParameters><key>TraceUniqueID</key><value>000000404301607272139189364004</value></NamedParameters></ns1:extensionInfo></ns1:syncOrderRelationship></soapenv:Body></soapenv:Envelope>' http://mx.smt.lsmhub.net/syncOrderRelationship | grep resultCode | cut -c33-40)


# test value
#echo $SMT_HANDLER_STATE

if [ $SMT_HANDLER_STATE = "00000000" ]; then
echo "OK - SMT-Handler UP & Running."
exit 0
else
echo "ERROR !! - CALL Sysadmin!!"
exit 2
echo $?
fi

