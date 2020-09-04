clear all;
I=imread('C:\Users\User\Downloads\db_bunga\melati\melati(20)putih.jpg');
figure(1),imshow(I);
title('image asli')
[N,M,L]=size(I);
Hk=12; Ck=5; Lk=5;                      % set ukuran kuantisasi H, C dan L
HCL_Histo(1:Hk,1:Ck+1,1:Lk)=0;          % inisialisasi matriks histogram ruang HCL
gamma=10;                               % set nilai gamma
Q=exp(gamma/100.0);                     % hitung Q warna putih
Ldiv=round((2*Q-1.0)*255/(2.0* Lk));    % hitung pembagi L dalam 5 bagian
Cdiv=round(2*255*Q/(3.0*Ck));           % hitung pembagi C dalam 5 bagian
Hdiv=30;

for n=1:N
    for m=1:M
       b=double(I(n,m,3)); g=double(I(n,m,2)); r=double(I(n,m,1));   % nilai komponen R, G dan B
       Max = max(r,max(g,b));                                        % hitung nilai maksimum
         Min = min(r,min(g,b));                                      % hitung nilai minimum
         if Max==0 Q=1.0;      
            else Q=exp((Min*gamma)/(Max*100.0));                     % hitung nilai Q
         end
              L=floor((Q*Max+(Q-1.0)*Min)/(2.0*Ldiv));              % hitung nilai L dan kuantisasi
              rg=(r-g); gb=(g-b);
              C=(abs(b-r)+abs(rg)+abs(gb))*Q/(3.0);                  % hitung nilai C 
              if C<=5 C=0;                                           % kuantisasi nilai C
               else C = 1+floor((C-5)/Cdiv);
              end
              H=atan(gb/rg);                                          % hitung nilai H
         if(C==0) H=0.0;
            elseif (rg>=0 && gb>=0)  H= 2*H/3;
            elseif ((rg>=0) && gb<0) H=4*H/3;
            elseif (rg<0 && gb>=0)  H= pi + 4*H/3;
            elseif ((rg<0) && gb<0 ) H= 2*H/3 - pi;
         end;
     H=H*(180/pi)+Hdiv/2;                      % konversi H dari radian ke derajat dan kuantisasi
   if H<0 H=floor((360+H)/(Hdiv));  
     else  H=floor(H/(Hdiv));
   end
   HCL_Histo(H+1,C+1,L+1)=HCL_Histo(H+1,C+1,L+1)+1;     % hitung histogram
  end;
end;

HCL_Histo=(100*HCL_Histo/(N*M));      % hitung histogram dalam persentase

a = HCL_Histo(: , : , 4 )                  % tampilkan nilai histogram warna 
