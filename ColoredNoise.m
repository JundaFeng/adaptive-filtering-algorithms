clear all; close all;
L=512;  %���泤��
d=[1 -1.5 0.7 0.1]; c=[1 0.5 0.2];  % ���ӷ�ĸ����ʽϵ��
nd=length(d)-1 ;nc=length(c)-1;  %�״�
xik=zeros(nc,1);  %��������ֵ
ek=zeros(nd,1);
xi=randn(L,1);  %������ֵΪ0������Ϊ1�ĸ�˹����������

for k=1:L
   e(k)=-d(2:nd+1)*ek+c*[xi(k);xik];  %������ɫ����
    %���ݸ���
    for i=nd:-1:2
       ek(i)=ek(i-1);
    end
   ek(1)=e(k);
    for i=nc:-1:2
       xik(i)=xik(i-1);
    end
   xik(1)=xi(k);
end

a = 1;gama = 1;ms = 1;
vn = iws(a,gama,ms,L);
subplot(3,1,1);
plot(xi,'k');
xlabel('(a)');
title('��˹����������');
subplot(3,1,2);
plot(e,'k');
xlabel('(b)');
ylabel('��ֵ');title('��ɫ��������');
subplot(3,1,3);
plot(vn,'k');
xlabel('(c)');title('\alpha-�ȶ��ֲ���������');


