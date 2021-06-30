% Pelletreau-Duris Tom et Maika Touzet
% Groupe4
% TP - Analyse biométrique
% Nettoyage
clear all
close all
clc

% Initialisation
M=2001;
fech=1000;
TpsD=0:M-1;
TpsP=TpsD/fech;
Ntot=[13,17,21,27,35,47,59,77,99,135,189];

%%

% Analyse fréquentielle d'un signal
% Bruit Blanc Gaussien Centré

BruitBlancGaussienCentre=randn(1,M); %Génération d'un bruit blanc gaussien centré
figure,clf

% Représentation temporelle du bruit gaussien centré
subplot(2,1,1);
plot(TpsP,BruitBlancGaussienCentre),
yline(0,'--'),yline(-0.5,'-.'),yline(0.5,'-.');
title('Bruit blanc gaussien centré')
xlabel('Temps (sec)')
ylabel('Amplitude')

% Représentation temps-fréquence
tF=sqrt(M); % Taille de la fenêtre
noverlap = round(tF/2); % Taux de recouvrement
nbpoint = 2048; % de la forme 2^n avec n entier naturel et nbpoint>M
subplot(2,1,2);
spectrogram(BruitBlancGaussienCentre,tF,noverlap,nbpoint,fech,'yaxis');
xlabel('Temps (sec)')
ylabel('Fréquence (Hz)')

%%

% Analyse fréquentielle d'un signal
% Bruit blanc gaussien de moyenne 7 et sigma=3 (variance 9)

moy=7;
sigma=9;
BruitBlanc=sqrt(sigma)*randn(1,M)+moy; % Génération du bruit
figure(2)

% Représentation temporelle du bruit
subplot(2,1,1);
plot(TpsP,BruitBlanc-moy),
yline(0,'--'),yline(sqrt(sigma)/2,'-.'),yline(-sqrt(sigma)/2,'-.');
title('Bruit blanc de moyenne 7 variance 9')
xlabel('Temps (sec)')
ylabel('Amplitude')

% Représentation temps-fréquence
tF=sqrt(M); % Taille de la fenêtre
noverlap = round(tF/2); % Taux de recouvrement
nbpoint = 2048; % de la forme 2^n avec n entier naturel et nbpoint>M
subplot(2,1,2);
spectrogram(BruitBlanc-moy,tF,noverlap,nbpoint,fech,'yaxis');
xlabel('Temps (sec)')
ylabel('Fréquence (Hz)')

%%

% Régularité d'un signal
% Méthode DFA3

% Profil du signal
y = randn(1,M) ;
y = y-mean(y) ;
yint = cumsum(y);
figure,plot(TpsP,yint)
title('Profil')
xlabel('Temps(sec)')
ylabel('yint')

% Calcul des tendances
F=zeros(1,11);
figure,
for i=1:11 % Calcul pour chaque valeur de N
    N=Ntot(i); % Taille des segments
    L=floor(M/N); % Nombre de segments
    X=zeros(L,N);
    x=zeros(1,N);
    TendancesLocales=zeros(1,M);
    % Calcul de la tendance locale pour chaque segment l
    for l=1:L
        for n=1:N
            x(n)=(l-1)*N+n;
        end
        a=polyfit(x,yint(((l-1)*N+1):(l*N)),3); % Régression d'ordre 3
        for n=1:N
            X(l,n)=a(1)*x(n)^3+a(2)*x(n)^2+a(3)*x(n)+a(4);
        end
    end
    % Concaténation des tendances locales
    for l=1:L
        TendancesLocales((l-1)*N+1:l*N)=X(l,:);
        for n=1:N
            F(i)=F(i)+(yint((l-1)*N+n)-X(l,n))^2;
        end
    end
    F(i)=sqrt(1/(L*N)*F(i));
    % Tracé des tendances
    subplot(4,3,i),plot(TpsP,yint)
    hold on
    plot(TpsP,TendancesLocales)
    title(strcat("N=",num2str(N)))
    xlabel('Temps(sec)')
    ylabel('yint')
    for l=1:L
        xline((l*N)/fech)
    end
end

% Régression linéaire et coefficient de Hurst
line=polyfit(log(Ntot),log(F),1);
alpha=line(1);
figure,scatter(log(Ntot),log(F))
xlabel("log(N)"),ylabel("log(F(N))")
refline(line)

%%

% Test sur signaux synthétiques de régularité connue
% Bruit blanc gaussien centré

alphaTot=zeros(1,50);
for k=1:50
    % Génération d'un nouveau bruit
    y = randn(1,M) ;
    y = y-mean(y) ;
    yint = cumsum(y);
    % Calcul des tendances
    F=zeros(1,11);
    for i=1:11
        N=Ntot(i);
        L=floor(M/N);
        X=zeros(L,N);
        x=zeros(1,N);
        % Calcul de la tendance locale pour chaque segment l
        TendancesLocales=zeros(1,M);
        for l=1:L
            for n=1:N
                x(n)=(l-1)*N+n;
            end
            a=polyfit(x,yint(((l-1)*N+1):(l*N)),3);
            for n=1:N
                X(l,n)=a(1)*x(n)^3+a(2)*x(n)^2+a(3)*x(n)+a(4);
            end
        end
        % Concaténation des tendances locales
        for l=1:L
            TendancesLocales((l-1)*N+1:l*N)=X(l,:);
            for n=1:N
                F(i)=F(i)+(yint((l-1)*N+n)-X(l,n))^2;
            end
        end
        F(i)=sqrt(1/(L*N)*F(i));
    end
    % Régression linéaire et coefficient de Hurst
    line=polyfit(log(Ntot),log(F),1);
    alphaTot(k)=line(1);
end

moyAlpha=mean(alphaTot); % Moyenne des alphas obtenus
varAlpha=var(alphaTot); % Variance des alphas obtenus

%%

% Test sur signaux synthétiques de régularité connue
% Bruit blanc non centré

alphaTot=zeros(1,50);
for k=1:50
    % Génération d'un nouveau bruit
    y = sqrt(9)*randn(1,M)+7 ;
    y = y-mean(y) ;
    yint = cumsum(y);
    % Calcul des tendances
    F=zeros(1,11);
    for i=1:11
        N=Ntot(i);
        L=floor(M/N);
        X=zeros(L,N);
        x=zeros(1,N);
        % Calcul de la tendance locale pour chaque segment l
        TendancesLocales=zeros(1,M);
        for l=1:L
            for n=1:N
                x(n)=(l-1)*N+n;
            end
            a=polyfit(x,yint(((l-1)*N+1):(l*N)),3);
            for n=1:N
                X(l,n)=a(1)*x(n)^3+a(2)*x(n)^2+a(3)*x(n)+a(4);
            end
        end
        % Concaténation des tendances locales
        for l=1:L
            TendancesLocales((l-1)*N+1:l*N)=X(l,:);
            for n=1:N
                F(i)=F(i)+(yint((l-1)*N+n)-X(l,n))^2;
            end
        end
        F(i)=sqrt(1/(L*N)*F(i));
    end
    % Régression linéaire et coefficient de Hurst
    line=polyfit(log(Ntot),log(F),1);
    alphaTot(k)=line(1);
end

moyAlpha=mean(alphaTot); % Moyenne des alphas obtenus
varAlpha=var(alphaTot); % Variance des alphas obtenus

%%

% Régularité d'un signal
% Méthode DMA

y = randn(1,M) ;
y = y-mean(y) ;
yint = cumsum(y);

% Zeros pour N=13
z=[1;exp(2*j*pi/13);exp(4*j*pi/13);exp(6*j*pi/13);exp(8*j*pi/13);
    exp(10*j*pi/13);exp(12*j*pi/13);exp(14*j*pi/13);exp(16*j*pi/13);
    exp(18*j*pi/13);exp(20*j*pi/13);exp(22*j*pi/13);exp(24*j*pi/13)];
% Pôle
p=1;
% Représentation du pôle et des zéros pour N=13
figure,zplane(z,p)
title("Représentation du pôle et des zéros du filtre")
legend("zéros","pôle")

B=[1,-1,0,0,0,0,0,0,0,0,0,0,0];
A=[1,0,0,0,0,0,0,0,0,0,0,0,-1];
% Représentation du module et de la phase pour N=13
figure,freqz(A,B,M)
title("Module et phase de la fonction de transfert du filtre")

% Tendance globale du signal
tendance=zeros(11,M);
figure
for i=1:11
    N=Ntot(i);
    a=[N -N];
    b=zeros(1,N+1);
    b(1)=1;
    b(N+1)=-1;
    tendance(i,:)=filter(b,a,yint);
    tend=tendance(i,:);
    % Tracé du signal filtré
    subplot(4,3,i)
    plot(TpsP,yint)
    hold on
    plot(TpsP,tend)
    title(strcat("N=",num2str(N)))
    xlabel("Temps(sec)"),ylabel("yint")
end

% Correction du retard de groupe
figure
for i=1:11
    N=Ntot(i);
    a=1;
    b=1/N*ones(1,N);
    tendance(i,:)=filter(b,a,yint);
    tend=tendance(i,:);
    % Tracé des tendances corrigées
    subplot(4,3,i)
    plot(TpsP(1:M-(N-1)/2),yint(1:M-(N-1)/2))
    hold on
    plot(TpsP(1:M-(N-1)/2),tend((N-1)/2+1:M))
    title(strcat("N=",num2str(N)))
    xlabel("Temps(sec)"),ylabel("yint")
end

% Calcul de F
F=zeros(1,11);
for i=1:11
    N=Ntot(i);
    tend=tendance(i,:);
    res=yint(1:M-(N-1)/2)-tend((N-1)/2+1:M); % Résidu
    F(i)=sqrt(sum(res.^2)/length(res));
end

% Régression linéaire
line=polyfit(log(Ntot),log(F),1);
alpha=line(1);
figure,scatter(log(Ntot),log(F))
xlabel("log(N)"),ylabel("log(F(N))")
refline(line)

%%

% Test sur signaux synthétiques de régularité connue
% Bruit blanc gaussien centré

alphaTot=zeros(1,50);
M=2001;
for k=1:50
    y = randn(1,M) ;
    y = y-mean(y) ;
    yint = cumsum(y);
    
    % Tendance globale du signal
    tendance=zeros(11,M);
    for i=1:11
        N=Ntot(i);
        a=[N -N];
        b=zeros(1,N+1);
        b(1)=1;
        b(N+1)=-1;
        tendance(i,:)=filter(b,a,yint);
    end
    
    F=zeros(1,11);
    for i=1:11
        N=Ntot(i);
        tend=tendance(i,:);
        res=yint((N+1)/2:M-(N-1)/2)-tend(N:M); % Résidu
        F(i)=sqrt(sum(res.^2)/length(res));
    end
    
    % Régression linéaire
    line=polyfit(log(Ntot),log(F),1);
    alphaTot(k)=line(1);
end

moyAlpha=mean(alphaTot); % Moyenne des alphas obtenus
varAlpha=var(alphaTot); % Variance des alphas obtenus


%%

% Test sur signaux synthétiques de régularité connue
% Bruit blanc non centré

alphaTot=zeros(1,50);
for k=1:50
    y = 3*randn(1,M)+7 ;
    y = y-mean(y) ;
    yint = cumsum(y);
    
    % Tendance globale du signal
    tendance=zeros(11,M);
    for i=1:11
        N=Ntot(i);
        a=[N -N];
        b=zeros(1,N+1);
        b(1)=1;
        b(N+1)=-1;
        tendance(i,:)=filter(b,a,yint);
    end
    
    F=zeros(1,11);
    for i=1:11
        N=Ntot(i);
        tend=tendance(i,:);
        res=yint((N+1)/2:M-(N-1)/2)-tend(N:M); % Résidu
        F(i)=sqrt(sum(res.^2)/length(res));
    end
    
    % Régression linéaire
    line=polyfit(log(Ntot),log(F),1);
    alphaTot(k)=line(1);
end

moyAlpha=mean(alphaTot); % Moyenne des alphas obtenus
varAlpha=var(alphaTot); % Varince des alphas obtenus

%%

% Mise en oeuvre sur des signaux physiologiques
% DFA3
% Electrode 7

load("dataEEG2020.mat");
alphaDFA1=zeros(2,7);
for i=1:2
    for m=1:7 % Pour chaque signal (sujet) de l'électrode 7
        % On applique la méthode DFA3
        F=zeros(1,11);
        y = cell2mat(dataEEG2020e7(i,m));
        y = y-mean(y);
        yint = cumsum(y);
        for k=1:11
            N=Ntot(k);
            L=floor(M/N);
            X=zeros(L,N);
            x=zeros(1,N);
            TendancesLocales=zeros(1,M);
            for l=1:L
                for n=1:N
                    x(n)=(l-1)*N+n;
                end
                a=polyfit(x,yint(((l-1)*N+1):(l*N)),3);
                for n=1:N
                    X(l,n)=a(1)*x(n)^3+a(2)*x(n)^2+a(3)*x(n)+a(4);
                end
            end
            for l=1:L
                TendancesLocales((l-1)*N+1:l*N)=X(l,:);
                for n=1:N
                    F(k)=F(k)+(yint((l-1)*N+n)-X(l,n))^2;
                end
            end
            F(k)=sqrt(1/(L*N)*F(k));
        end
        line=polyfit(log(Ntot),log(F),1);
        alphaDFA1(i,m)=line(1);
    end
end

% Représentation graphique des alphas obtenus
figure,
plot(alphaDFA1(1,:))
hold on
plot(alphaDFA1(2,:))
yline(0.85,"--")
legend("phase 1","phase 2","seuil de séparabilité")
xlabel("Sujet")
ylabel("Coefficient de Hurst")
title("Méthode DFA, électrode 7")

anova1(alphaDFA1.') % Anova entre les phases

%%

% Mise en oeuvre sur des signaux physiologiques
% DFA3
% Electrode 8

load("dataEEG2020.mat");
alphaDFA2=zeros(2,7);
for i=1:2
    for m=1:7
        F=zeros(1,11);
        y = cell2mat(dataEEG2020e8(i,m));
        y=y-mean(y);
        yint = cumsum(y);
        for k=1:11
            N=Ntot(k);
            L=floor(M/N);
            X=zeros(L,N);
            x=zeros(1,N);
            TendancesLocales=zeros(1,M);
            for l=1:L
                for n=1:N
                    x(n)=(l-1)*N+n;
                end
                a=polyfit(x,yint(((l-1)*N+1):(l*N)),3);
                for n=1:N
                    X(l,n)=a(1)*x(n)^3+a(2)*x(n)^2+a(3)*x(n)+a(4);
                end
            end
            for l=1:L
                TendancesLocales((l-1)*N+1:l*N)=X(l,:);
                for n=1:N
                    F(k)=F(k)+(yint((l-1)*N+n)-X(l,n))^2;
                end
            end
            F(k)=sqrt(1/(L*N)*F(k));
        end
        
        line=polyfit(log(Ntot),log(F),1);
        alphaDFA2(i,m)=line(1);
    end
end

figure,
plot(alphaDFA2(1,:))
hold on
plot(alphaDFA2(2,:))
legend("phase 1","phase 2")
xlabel("Sujet")
ylabel("Coefficient de Hurst")
title("Méthode DFA, électrode 8")

anova1(alphaDFA2.')

%%

% Mise en oeuvre sur des signaux physiologiques
% DMA
% Electrode 7

load("dataEEG2020.mat");
alphaDMA1=zeros(2,7);
Ntot=[13,17,21,27,35,47,59,77,99,135,189];
F=zeros(1,11);
for i=1:2
    for m=1:7
        y = cell2mat(dataEEG2020e7(i,m));
        y = y-mean(y) ;
        yint = cumsum(y);
        for k=1:11
            N=Ntot(k);
            a=[N -N];
            b=zeros(1,N+1);
            b(1)=1;
            b(N+1)=-1;
            tend=filter(b,a,yint);
            res=yint((N+1)/2:M-(N-1)/2)-tend(N:M);
            F(k)=sqrt(sum(res.^2)/length(res));
        end
        
        line=polyfit(log(Ntot),log(F),1);
        alphaDMA1(i,m)=line(1);
    end
end

figure,
plot(alphaDMA1(1,:))
hold on
plot(alphaDMA1(2,:))
legend("phase 1","phase 2")
xlabel("Sujet")
ylabel("Coefficient de Hurst")
title("Méthode DMA, électrode 7")

anova1(alphaDMA1.')

%%

% Mise en oeuvre sur des signaux physiologiques
% DMA
% Electrode 8

load("dataEEG2020.mat");
alphaDMA2=zeros(2,7);
Ntot=[13,17,21,27,35,47,59,77,99,135,189];
F=zeros(1,11);
for i=1:2
    for m=1:7
        y = cell2mat(dataEEG2020e8(i,m));
        y = y-mean(y) ;
        yint = cumsum(y);
        for k=1:11
            N=Ntot(k);
            a=[N -N];
            b=zeros(1,N+1);
            b(1)=1;
            b(N+1)=-1;
            tend=filter(b,a,yint);
            res=yint((N+1)/2:M-(N-1)/2)-tend(N:M);
            F(k)=sqrt(sum(res.^2)/length(res));
        end
        
        line=polyfit(log(Ntot),log(F),1);
        alphaDMA2(i,m)=line(1);
    end
end

figure,
plot(alphaDMA2(1,:))
hold on
plot(alphaDMA2(2,:))
legend("phase 1","phase 2")
xlabel("Sujet")
ylabel("Coefficient de Hurst")
title("Méthode DMA, électrode 8")

anova1(alphaDMA2.')