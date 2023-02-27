close all;
%% ����
N = 100000;%�����źų���
L = 128;%�˲�������
pi = 3.14;%Բ����
M = 8;%ͶӰ����
varepsilon = 0.01;%��ֹdivide error
delta = 0.01;%��ֹ����ϵ����Ϊ0ʱ�㷨���ᣨ��������Ϊ0��
% rou = 5/L;%��ֹĳ��ϵ����Сʱ��ϵ�������£��ɱ�������ı���Ϊ0��
theta = 0;%ϵͳϡ���
alpha = 1-M/(4*L);%ƽ������
Nw = 16;%�����������ƵĹ��ƴ�
C = 1.483*(1+5/(Nw-1));%������ֵ��������

%% ����ͶӰ����
Xap = zeros(M,L);

%% ��������
e = zeros(N,M);
Ae = zeros(L,Nw);
Be = zeros(L,Nw);
beta = zeros(1,N);
sigma_x = zeros(1,N);
sigma_e = zeros(1,N);
sigma_v = zeros(1,N);
r = zeros(1,Nw);
%% �ŵ�ģ��
k = 1:L;
h = 1./k.*exp(-(k-L/2).^2/8000).*sin(pi*(k-1)/6);
figure(1)
plot(h);title('��ϡ���ŵ�');hold on;

he = zeros(N,L);% �ŵ����ƾ��󣬼�¼���������еı仯

%% �����ź�Ϊɫ����
num = [1];
den = [1,-0.9];
x = filter(num,den,randn(1,N));
figure(2)
plot(x);title('��ɫ�ź�');
x=10*randn(1,N);

%% alpha-stable clutter ����ʱ������
a = 1.5;gama = 1.5;ms = 1;
vn = iws(a,gama,ms,N);
figure(3)
plot(vn);
title('����v');
%% �䲽��
mu = ones(1,N);

%% ����ϵ������
g = ones(1,L);
t=1;

%% ����
mu0 = norm(h,inf)/20;

sigma_x(L+M-1) = var(x(1:L+M));
for k = L+M:N
    for i = 1:L
        Xap(:,i) = x(k+1-i:-1:k+2-M-i)';
    end
    g = (1-theta)/(2*L)+(1+theta)*abs(he(k,:))/(2*norm(he(k,:),1)+varepsilon);
    G = diag(g);
    e(k,:) = (Xap*h'-Xap*he(k,:)')'+vn(k:-1:k-M+1);
    if mod(k-L-M,Nw)==0
        t=t+1;
        Ae = e(k:-1:k-Nw+1,:)';
        Be = e(k:-1:k-Nw+1,:).^2';
        r = alpha*r+C*(1-alpha)*x(k)*median(Ae);
        sigma_x(t) = alpha*sigma_x(t-1)+(1-alpha)*mu(t-1)^2*0.5;
        sigma_e(t) = alpha*sigma_e(t-1)+C*(1-alpha)*median(median(Be))*0.5;
        sigma_v(t) = sigma_e(t)+r*r'/sigma_x(t)*0.5;
        beta(t) = (norm(e(t,:),1)-M*sqrt(2/pi*sigma_v(t)))/sqrt(sign(e(t,:))*(Xap*Xap')*sign(e(t,:)'));
        SignOfBeta = [mu(t-1),0,beta(t)];%����if else
        beta(t) = SignOfBeta(sign(beta(t))+2);%�Ѹ���ӳ��Ϊ�±�1��������ӳ��Ϊ�±�3
        mu(t) = alpha*mu(t-1)+(1-alpha)*min(beta(t),mu(t-1));
    end
    he(k+1,:) = he(k,:)+mu0*mu(t)*sign(e(k,:))*Xap*G*inv(sqrt(sign(e(k,:))*Xap*G*Xap'*sign(e(k,:)')));
%      figure(1);
%      fig=plot(he(k,:),'r');title('�ŵ�����');drawnow;
%      set(fig,'visible','off');
%      figure(3)
%      plot([vn(1:k),zeros(1,N-k)]);drawnow;
end

%%
figure(4);
plot(mean(e(1:N,:),2).^2,'b');
xlabel('��������');
ylabel('�������');
title('VSS_IPAPSA')
% saveas(gcf,'C:\Work\����\codes\pic0409\VSS_IPAPSA_MSE.png')

figure(5)
Misalign_VSS_IPAPSA = 10*log10(sum((he-h).^2,2)/sum(h.^2));
plot(Misalign_VSS_IPAPSA)
xlabel('��������');
ylabel('ϵ��ʧ��(dB)');
title('VSS_IPAPSA');
% saveas(gcf,'C:\Work\����\codes\pic0409\VSS_IPAPSA_Misalignment.png')
% 
% figure(6)
% plot(he(N,:))
% 
