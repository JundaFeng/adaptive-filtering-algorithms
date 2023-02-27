%% Generation of complex isotropic SaS random variables
% ��1��Simulation of Dependent Samples of Symmetric Alpha-Stable Clutter
% ��2��On the Chambers-Mallows-Stuck method for simulating skewed stable random variables
% ��3��The robust covariation-based MUSIC (ROC-MUSIC) algorithm for bearing estimation in impulsive noise environments
%% �˺����ο������ס�3��
function x=iws(alpha,gama,ms,ns)
% 0<alpha<=2:��SaS����ָ��
% sigmaG:��Gaussian����
%% �������ס�1��ʽ(4)���������Alpha�ֲ�����
p1=(2-alpha)/alpha;
rand('state',sum(100*clock));
vv=pi*(rand	(ms,ns));% ����(0,pi)�ľ��ȷֲ��������
rand('state',7*sum(100*clock)+3);
ww=-log(1-rand(ms,ns));% ������ֵΪ1��ָ���ֲ��������
yAw=sin(alpha*vv/2)./(sin(vv)).^(2/alpha).*(sin((1-alpha/2)*vv)./ww).^p1;% ����nonnegative innovations ��(k)
%% �������ס�1��ʽ(3)����Gaussian�ֲ�����
sigmaG=4;
sigmaG_dB=10*log10(sigmaG);
yGw=wgn(ms,ns,sigmaG_dB,'real');
xasigmac=std(yGw);
xamuc=mean(yGw);
yG=2*(yGw-xamuc)/xasigmac;
%% ��������ظ�S��S�������
x=gama^(1/alpha)*sqrt(yAw).*yG;
%% ���Ʒ���ظ�SaS���в���
sigmaA=sqrt(sigmaG)/2;
gama=sigmaA^alpha;



