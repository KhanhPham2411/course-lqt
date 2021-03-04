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
//| Expert initialization function                                   |
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
      
      // "EURUSD" string
      string sym = "GBPUSD";
      
      int loaiLenh;
      loaiLenh = OP_SELL;
      // buy --> Ask
      // sell --> Bid 
      // buy stop --> gia vao lenh > gia hien tai
      // sell stop --> gia vao lenh < gia hien tai
      
      
      double khoiLuong;
      khoiLuong = 0.1;
      
      double stoploss = 1.39015;
      double takeprofit = 1.38615;
      string ghichu = "hello";
      color maucualenh = clrGreen;
      int doTruotGia = 20; // points
      
      OrderSend(sym, loaiLenh, khoiLuong, Bid, doTruotGia, stoploss, takeprofit, ghichu, 0, 0, maucualenh);
   
   
   
  }
//+------------------------------------------------------------------+
