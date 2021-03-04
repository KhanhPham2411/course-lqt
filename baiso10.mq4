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
extern double stoploss = 3;
extern double takeprofit = 3;
extern string ghichu = "hello";
extern color maucualenh = clrGreen;
extern int doTruotGia = 20;
datetime thoigiangiaodich;
int magic = 999;
double lastLotsize;
double lasttime;
double lastprofit;
int lasttype;

//+------------------------------------------------------------------+
int OnInit()
  {
//---
   checkLicense();
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
      if(demsolenh(Symbol()) > 0){return;}
      
      // vao lenh vao dau cay nen moi
      datetime current = iTime(Symbol(), 0, 0);
      if (current == thoigiangiaodich){ return;}
      thoigiangiaodich = current;
      
      if(lenhcuoicung(Symbol()) > 0) { khoiLuong = 0.01;}     // 0    +1
      if(lenhcuoicung(Symbol()) <= 0) { khoiLuong = lastLotsize*2; loaiLenh = (lasttype+1)%2;}

      //Comment(lastLotsize);
         
      // order
      enter_order(Symbol(), loaiLenh, khoiLuong, 0, stoploss, takeprofit, magic, ghichu);
  }
//+------------------------------------------------------------------+


double lenhcuoicung(string symm)
{  
   double lastprofit;       
   datetime lasttime;

   for(int i =0; i <= OrdersHistoryTotal()-1; i++)
   {
      if(OrderSelect(i, SELECT_BY_POS,MODE_HISTORY)==false)  {continue;}
      if(OrderSymbol() != symm){continue;}
      if(OrderMagicNumber()!= magic){continue;}
      if(OrderType()>1){continue;}
      
      if(OrderCloseTime() > lasttime)
      {
         lasttime = OrderCloseTime(); // 6h
         lastprofit = OrderProfit();
         lastLotsize = OrderLots();
         lasttype = OrderType();
      }  
   }

   return (lastprofit);
}
double normalize_lot(double lot, string sym)
{
   int normallotunit;
   if(MarketInfo(sym, MODE_MINLOT) == 0.01){normallotunit = 2;}
   if(MarketInfo(sym, MODE_MINLOT) == 0.1){normallotunit = 1;}
   if(MarketInfo(sym, MODE_MINLOT) == 0.001){normallotunit = 3;}
   return NormalizeDouble(lot, normallotunit);
}
void enter_order(string sym, int type, double lot, double price, double sl_pip, double tp_pip, int magic, string comment)
{
   if (lot == 0) {return;}
   lot = normalize_lot(lot, sym);
   
   double sl_price, tp_price; color color_type;
   if (type == OP_BUY)
   {
      price = MarketInfo(sym, MODE_ASK);
      sl_price = price - sl_pip*10*MarketInfo(sym, MODE_POINT);
      tp_price = price + tp_pip*10*MarketInfo(sym, MODE_POINT);
      color_type = clrBlue;
   }
   if (type == OP_SELL)
   {
      price = MarketInfo(sym, MODE_BID);
      sl_price = price - sl_pip*10*MarketInfo(sym, MODE_POINT);
      tp_price = price + tp_pip*10*MarketInfo(sym, MODE_POINT);
      color_type = clrRed;
   }
   
   price = NormalizeDouble(price, MarketInfo(sym, MODE_DIGITS));
   sl_price = NormalizeDouble(sl_price, MarketInfo(sym, MODE_DIGITS));
   tp_price = NormalizeDouble(tp_price, MarketInfo(sym, MODE_DIGITS));
   
   //ENCN, STP, OM LENH
   // send order
   double orderId = OrderSend(sym, type, lot, price, 20, 0, 0, comment, magic, 0, color_type);
   // modify sl, tp
   bool success = false; int count;
   if (orderId > 0 && sl_price !=0 && tp_price != 0)
   {
      while(success == false && count < 20)
      {
         success = OrderModify(sym, price, sl_pip, tp_pip, 0, clrNONE);
         count ++;
         Sleep(50);
      }
      int error = GetLastError();
      if (error != 0 && error != 1){ Alert("bi loi: " + error);}
   }
}
double dinhdangLot()
{
   // Comment(khoiLuong);
   if(khoiLuong ==0){khoiLuong = MarketInfo(Symbol(),MODE_MINLOT);}
   
   double maxlot = MarketInfo(Symbol(),MODE_MAXLOT);
   if(khoiLuong > maxlot){khoiLuong = maxlot;}
   
   khoiLuong = NormalizeDouble(khoiLuong, 2); // 0.0145454 --> 0.01
   
   return(khoiLuong);
}
void checkLicense()
{
   if(IsTradeAllowed() == false)
   {
      Alert("Hay click vao trade allow");
   }
}
int demsolenh(string symbol)
{
   int count = 0;
   for(int i = OrdersTotal()-1; i>= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS)==False) {continue;}
      if(OrderSymbol() != symbol) {continue;}
      if(OrderMagicNumber() != magic) {continue;}
      
      count ++;
   }
   return count;
}
void get_candle()
{
   for (int n=500; n >= 0; n--)
   {
      double high2, low2, high1, low1;
      high2 = iHigh(Symbol(), 0, n+1);
      low2 = iLow(Symbol(), 0, n+1);
      
      high1 = iHigh(Symbol(), 0, n);
      low1 = iLow(Symbol(), 0, n);
      
      if(high2 < high1 && low2 > low1)
      {
         Comment("Engulfing: " + n);
      }
   }
   
   /*int max_candle, min_candle;
   max_candle = iHighest(Symbol(), 0, MODE_HIGH, 100, 0);
   min_candle = iLowest(Symbol(), 0, MODE_LOW, 100, 0);
   

   double highest = iHigh(Symbol(), 0, max_candle);
   double lowest = iLow(Symbol(), 0, min_candle);
   
   Comment(highest + "/" + lowest);*/
}
