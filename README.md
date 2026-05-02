# Forecasting USD/VND exchange rate: Macroeconomic impact & deep learning (2015 - 2025)

Project overview
This project explores how macroeconomic factors drive the USD/VND exchange rate and builds predictive models to forecast its movement. It combines traditional econometrics in STATA with deep learning in Python to understand market behavior and predict future rates.

Key findings
The analysis shows that Vietnam government bond yields and foreign exchange reserves heavily influence the exchange rate. Interestingly, the data proves that the Vietnamese foreign exchange market is highly asymmetric, meaning it panics over bad news much more than it reacts to good news.

On the forecasting side, the ARMAX(1,6)-EGARCH(1,1) model proved best for capturing this market volatility. Furthermore, the LSTM neural network built in Python successfully predicted exchange rate trends with an error rate (MAPE) of under 0.4%, proving the effectiveness of machine learning in financial forecasting.

Tech stack and data
The project uses Python for machine learning (LSTM) and STATA for time series analysis (OLS, ARMAX, GARCH family). The dataset consists of over 500 weekly observations from 2015 to 2025, sourced from FRED, Investing, and Trading Economics.
'''
Repository structure
├── data/
│ ├── Data_week
│ └── Data_day
├── code/
│ ├── main.do
│ └── lstm_prediction.ipynb
├── images
│ └── lstm chart
└── README.md
'''
