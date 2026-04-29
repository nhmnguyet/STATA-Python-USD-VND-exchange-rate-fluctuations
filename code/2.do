* Hiển thị biến thời gian dưới dạng ngày
format thoigian %td

* Tạo biến tuần
gen week = wofd(thoigian)
format week %tw

*Bo trung lap
duplicates drop week, force

* Khai báo chuỗi thời gian
tsset week

*Bang thong ke mo ta
summarize EX_US_VN CPI_VN CPI_US VNGB USFFR VNI SPX FDI_VN FDI_US IMEX_VN DXY VNFR

*tạo biến log (ln)
gen lnEX_US_VN = ln(EX_US_VN)
gen lnVNI     = ln(VNI)
gen lnSPX     = ln(SPX)
gen lnFDI_VN  = ln(FDI_VN)
gen lnFDI_US  = ln(FDI_US)
gen lnVNFR    = ln(VNFR)
*Kiểm tra biến mới
summarize lnEX_US_VN lnVNI lnSPX lnFDI_VN lnFDI_US lnVNFR

*Kiểm định tính dừng 1
foreach var in lnEX_US_VN CPI_VN CPI_US VNGB USFFR lnVNI lnSPX lnFDI_VN lnFDI_US IMEX_VN DXY lnVNFR {
    dfuller `var', lags(1)
}

*Kiểm định tính dừng 2 (tru lnFDI_VN, IMEX_VN)
foreach var in d.lnEX_US_VN d.CPI_VN d.CPI_US d.VNGB d.USFFR d.lnVNI d.lnSPX d.lnFDI_US d.DXY d.lnVNFR {
    dfuller `var', lags(1)
}

*Tao bien Sai phan bac 1 (tru lnFDI_VN, IMEX_VN)
foreach var in lnEX_US_VN CPI_VN CPI_US VNGB USFFR lnVNI lnSPX lnFDI_US DXY lnVNFR {
    gen d_`var' = D.`var'
}

*Ma tran he so tuong quan
corr d_lnEX_US_VN d_CPI_VN d_CPI_US d_VNGB d_USFFR d_lnVNI d_lnSPX d_lnFDI_US d_DXY d_lnVNFR lnFDI_VN IMEX_VN

*3.2. Kết quả ước lượng
*3.2.1.AR, MA, ARIMA, ARIMAX
*3.2.1.1. Công cụ AR
pac d_lnEX_US_VN
* AR models (pure AR)
arima d_lnEX_US_VN, arima(1,0,0)
estimates store ar1
estat ic

arima d_lnEX_US_VN, arima(6,0,0)
estimates store ar6
estat ic

arima d_lnEX_US_VN, arima(7,0,0)
estimates store ar7
estat ic

arima d_lnEX_US_VN, arima(10,0,0)
estimates store ar10
estat ic

arima d_lnEX_US_VN, arima(26,0,0)
estimates store ar26
estat ic

arima d_lnEX_US_VN, arima(29,0,0)
estimates store ar29
estat ic

*3.2.1.1. Mô hình MA
ac d_lnEX_US_VN
*Ước lượng từng mô hình MA(q)
arima d_lnEX_US_VN, ma(1)
estimates store ma1

arima d_lnEX_US_VN, ma(6)
estimates store ma6

arima d_lnEX_US_VN, ma(7)
estimates store ma7

arima d_lnEX_US_VN, ma(10)
estimates store ma10

arima d_lnEX_US_VN, ma(11)
estimates store ma11
*So sánh các mô hình để xem AIC, BIC, và Log likelihood
estimates stats ma1 ma6 ma7 ma10 ma11

*3.2.1.3. Mô hình ARMA
corrgram d_lnEX_US_VN

arima d_lnEX_US_VN, arima(1,0,1)
estat ic                     // báo AIC, BIC
drop ehat
predict ehat, resid
wntestq ehat, lags(20)       // Ljung–Box, kỳ vọng p>0.05

arima d_lnEX_US_VN, arima(1,0,6)
estat ic                     // báo AIC, BIC
drop ehat
predict ehat, resid
wntestq ehat, lags(20)       // Ljung–Box, kỳ vọng p>0.05






*[KHAC]3.2.1.4. Mô hình ARMAX
* ARMAX(1,1)
arima d_lnEX_US_VN d_lnSPX d_VNGB d_CPI_US d_lnVNFR, arima(1,0,1)
estimates store armax11
estat ic
drop e11
predict e11, resid
wntestq e11, lags(20)

* ARMAX(1,0)
arima d_lnEX_US_VN d_lnSPX d_VNGB d_CPI_US d_lnVNFR, arima(1,0,0)
estimates store armax12
estat ic
drop e12
predict e12, resid
wntestq e12, lags(20)

* ARMAX(0,1)
arima d_lnEX_US_VN d_lnSPX d_VNGB d_CPI_US d_lnVNFR, arima(0,0,1)
estimates store armax21
estat ic
drop e21
predict e21, resid
wntestq e21, lags(20)

* ARMAX(1,6)
arima d_lnEX_US_VN d_lnSPX d_VNGB d_CPI_US d_lnVNFR, arima(1,0,6)
estimates store armax22
estat ic
drop e22
predict e22, resid
wntestq e22, lags(20)


*3.2.1.5. So sánh và lựa chọn mô hình tốt nhất trong nhóm AR, MA, ARMA, ARMAX 
* AR(1)
arima d_lnEX_US_VN, arima(1,0,0)
estimates store ar1
estat ic
predict e_ar1, resid
wntestq e_ar1, lags(20)   // Ljung–Box cho AR(1)
*MA(1)
arima d_lnEX_US_VN, arima(0,0,1)
estimates store ma1
estat ic
predict e_ma1, resid
wntestq e_ma1, lags(20)   // Ljung–Box cho MA(1)

*ARMAX(1,6) 
*kiem tra do lech phan du
ssc install archlm
arima d_lnEX_US_VN d_lnSPX d_VNGB d_CPI_US d_lnVNFR, arima(1,0,6)
drop e16
predict e16, resid   
sktest e16
qnorm e16

*kiem tra hieu ung arch
drop ehat2
gen ehat2 = ehat^2
regress ehat2 L(1/12).ehat2
testparm L(1/12).ehat2          // p<0.05 ⇒ có ARCH

*CÓ ARCH ⇒ chuyển sang ARMA(1,6)-GARCH
** Chia mẫu: 8 tuần cuối làm test, còn lại là train (chỉ tính nơi y có dữ liệu)
summ week if !missing(d_lnEX_US_VN), meanonly
local last = r(max)
drop test
drop train
gen byte test  = inrange(week, `last'-10, `last') & !missing(d_lnEX_US_VN)
gen byte train = !test & !missing(d_lnEX_US_VN)

arch d_lnEX_US_VN d_lnSPX d_VNGB d_CPI_US d_lnVNFR if train, ar(1) ma(1) arch(1) garch(1) distribution(normal)
estat ic
drop uh
drop sh
drop uh2
predict uh, resid
predict sh, variance
gen uh2 = uh^2
wntestq uh2, lags(20)       

*Kiểm lại đúng biến cần test: dùng phần dư chuẩn hoá: 
drop eh
drop sh
predict eh, resid
predict sh, variance
drop z
drop z2
gen z  = eh/sqrt(sh)     
gen z2 = z^2
wntestq z2, lags(20)   

*kiểm tra độ chính xác của mô hình
**Dự báo giá trị fitted (bao gồm cả forecast out-of-sample)
drop yhat_all
predict yhat_all, y
drop yhat_test
gen yhat_test = yhat_all if test
drop err_test
gen err_test = d_lnEX_US_VN - yhat_test if test
drop ae_test
gen ae_test  = abs(err_test)
drop mape
gen mape     = 100*ae_test/abs(d_lnEX_US_VN) if test & d_lnEX_US_VN!=0
** RMSE
sum err_test if test
scalar RMSE = sqrt(r(Var) + (r(mean))^2)
** MAE
sum ae_test if test
scalar MAE = r(mean)
** MAPE
sum mape if test
scalar MAPE = r(mean)
** Hiển thị
di as text "RMSE  = " %9.5f RMSE
di as text "MAE   = " %9.5f MAE
di as text "MAPE% = " %9.3f MAPE


*3.2.3. ARMAX(1,6)–EGARCH(1,1)
arch d_lnEX_US_VN d_lnSPX d_VNGB d_CPI_US d_lnVNFR ///
    if train, ar(1) ma(1) earch(1) egarch(1) ///
    distribution(normal) vce(opg) ///
    technique(bhhh) difficult iterate(300)
*kiem dinh portmanteau
drop uh
drop uh2
predict uh, resid
gen uh2 = uh^2
wntestq uh2, lags(20)
	
*3.2.4. ARMAX–GARCH với phân phối phi chuẩn (GED)
arch d_lnEX_US_VN ///
    d_lnSPX d_VNGB d_CPI_US d_lnVNFR ///
    if train, ar(1) ma(1) arch(1) garch(1) ///
    distribution(ged) vce(opg) technique(bhhh) difficult iterate(300)
*[1311]* Lấy residual chuẩn hóa
predict e_std_norm, rstandard
*[1311] QQ plot so với phân phối chuẩn
qnorm e_std_norm
graph export qq_normal.png, replace

*kiem dinh portmanteau
drop uh
drop uh2
predict uh, resid
gen uh2 = uh^2
wntestq uh2, lags(20)

* Sau khi đã fit mô hình GED trên if train:
predict yhat, y
gen err    = d_lnEX_US_VN - yhat if !train
gen err2   = err^2 if !train
gen abs_e  = abs(err) if !train
gen hit    = ((d_lnEX_US_VN>0)==(yhat>0)) if !train

quietly summarize err2 if !train
scalar RMSE = sqrt(r(mean))
quietly summarize abs_e if !train
scalar MAE  = r(mean)
quietly summarize hit if !train
scalar DA   = 100*r(mean)

display "RMSE = " %9.6f RMSE
display "MAE  = " %9.6f MAE
display "DA%  = " %9.2f DA


