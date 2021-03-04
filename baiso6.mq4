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
datetime thoigiangiaodich;
int magic = 999;
      
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
      //if(OrdersTotal() > 0){return;}
      
      int count = demsolenh(Symbol());
      Comment(Symbol() + ": " + count);
      if(count > 0){return;}
      
      // vao lenh vao dau cay nen moi
      datetime current = iTime(Symbol(), 0, 0);
      if (current == thoigiangiaodich){ return;}
      thoigiangiaodich = current;
      
      if(Open[1] < Close[1]){ loaiLenh = OP_BUY;}
      if(Open[1] > Close[1]){ loaiLenh = OP_SELL;}
 
      
      double giavaolenh;//=0
      if(loaiLenh == OP_SELL)
      {
         maucualenh = clrRed;
         
         giavaolenh = Bid;
         stoploss = giavaolenh + 3*10*Point();
         takeprofit = giavaolenh - 6*10*Point();
      }
      if(loaiLenh == OP_BUY)
      { 
         giavaolenh = Ask;
         stoploss = giavaolenh - 3*10*Point();
         takeprofit = giavaolenh + 6*10*Point();
      }
      
      dinhdangLot();
      
      OrderSend(Symbol(), loaiLenh, khoiLuong, giavaolenh, doTruotGia, stoploss, takeprofit, ghichu, magic, 0, maucualenh);
  }
//+------------------------------------------------------------------+

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