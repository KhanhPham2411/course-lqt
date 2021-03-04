//+------------------------------------------------------------------+
//|                                                       baiso1.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function  
// Noi khai bao bien
extern int loaiLenh = OP_SELL;
extern double khoiLuong = 0.01;
extern double stoploss = 0;
extern double takeprofit = 0;
extern string ghichu = "hello";
extern color maucualenh = clrGreen;
extern int doTruotGia = 20;
      
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      if(OrdersTotal() > 0){return;}
      
      double giavaolenh;//=0
      if(loaiLenh == OP_SELL){ giavaolenh = Bid;  maucualenh = clrRed;}
      if(loaiLenh == OP_BUY){ giavaolenh = Ask;}
      
      
      OrderSend(Symbol(), loaiLenh, khoiLuong, giavaolenh, doTruotGia, stoploss, takeprofit, ghichu, 0, 0, maucualenh);
  }
//+------------------------------------------------------------------+
