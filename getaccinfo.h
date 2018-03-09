#ifndef GETACCINFO_H
#define GETACCINFO_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QByteArray>
#include <QString>
#include <QDir>
#include <QDate>
#include <QtSql>
#include <QSqlQuery>

class getAccInfo : public QObject
{
    Q_OBJECT
public:
    explicit getAccInfo(QObject *parent = nullptr);

    Q_INVOKABLE void autoreadFile(QString qstrMontreGauche, QString qstrMontreDroit);
    Q_INVOKABLE float getValueX(int lintIndex, bool lblMontre=0);
    Q_INVOKABLE float getValueY(int lintIndex, bool lblMontre=0);
    Q_INVOKABLE float getValueZ(int lintIndex, bool lblMontre=0);
    Q_INVOKABLE float getValue(int lintIndex, int lintAccelerometre, bool lblMontre=0);
    Q_INVOKABLE float getCombinaison(int lintIndex, bool lblMontre=0); // La valeur de la combinaison de tous les accéléromètres
    Q_INVOKABLE int getNbDonnees(); // Correspond aux nombre de float dans chaque fichier d'enregistrement
    Q_INVOKABLE int getNbAxes(bool lblMontre=0); // Nombre d'accéléromètre
    Q_INVOKABLE int getNbMouvements(bool lblMontre=0); // Calcule et retourne le nombre de mouvements détectés dans un fichier d'enregistrement
    Q_INVOKABLE float getNiveauRisque(int lintIndividu); // Calcule et retourne le nombre de mouvements détectés dans un fichier d'enregistrement
    Q_INVOKABLE float getMax(int lintAccelerometre=0, bool lblMontre=0); // Retourne le max d'un accéléromètre
    Q_INVOKABLE float getGeneralMax(bool lblMontre=0); // Retourne le max d'un accéléromètre
    Q_INVOKABLE float getGeneralMin(bool lblMontre=0); // Retourne le max d'un accéléromètre
    Q_INVOKABLE float getMin(int lintAccelerometre=0, bool lblMontre=0); // Retourne le min d'un accéléromètre donné.
    Q_INVOKABLE void setDureeTransmission(int lintNbSecondes);
    Q_INVOKABLE float getFltRythmeInstantMVT(bool lblMontre=0);
    Q_INVOKABLE float getFltRythmeMoyenMVT(bool lblMontre=0);
    Q_INVOKABLE int getDureeTotaleEnregistrement();
    Q_INVOKABLE int getDureeTotaleEnregistrementEnMinutes();
    Q_INVOKABLE int getIntNbTotalTransmission(); // peu importe qu'il ait réussi ou non à lire le fichier, il y a eu une nouvelle tentative de Transmission
    Q_INVOKABLE int getIntNbSuccesTransmission(); // Seulement les Transmissions avec lecture de fichiers réussie
    Q_INVOKABLE int getTempsTravail(); // retourne le temps de travail en secondes
    Q_INVOKABLE int getIntNbTotalMVT(bool lblMontre=0);
    Q_INVOKABLE int getTblIntNbMVT(int lintIndex, bool lblMontre=0);

    Q_INVOKABLE bool startTransmission(int lintIndividu /*numéro d'identifiant du travailleur */);
    Q_INVOKABLE QString getDBValue(QString qstrTable, QString qstrRow, int lintIndex);
    Q_INVOKABLE QString getMontreSN(int lintIndividu, bool lblMontreGauche=1);
    Q_INVOKABLE int getIndividuAge(int lintIndividu);
    Q_INVOKABLE int getNombreAgents(); // SELECT  count(Id) from Identites
    Q_INVOKABLE QString getAgentNomLst(int lintIndex, int lintStatus=-1); // SELECT Nom from Identites limit 1 offset lintIndex
    Q_INVOKABLE int getAgentId(int lintIndex); // SELECT Id from Identites limit 1 offset lintIndex
    Q_INVOKABLE int getAgentId(QString strSerialNo);
    Q_INVOKABLE QString getCoreMessage(QString strSerialNo, bool lblOffset);
    Q_INVOKABLE int getAgentStatus(int lintIndex);
    Q_INVOKABLE int getNombreSessions(int lintIndex);
    Q_INVOKABLE QString getSessiondDate(int lintIndividu, int lintIndex);
    Q_INVOKABLE QString getSessionDuration(int lintIndividu, int lintIndex);

    Q_INVOKABLE bool setSessionMustStart(int lintIndividu);

    Q_INVOKABLE int getNbDechets(bool lblMontre=0);
    Q_INVOKABLE int getNbDechetsTotal(bool lblMontre=0);

private:
    static const int MAXACCFILES = 3; // Nombre maximal de fichiers accéléromètres pouvant être utilisés
    static const int WATCHPERAGENT = 2;
    static const int MAXFILESIZE = 1000; // Taille maximale de chaque fichiers accéléromètre (en nombre de float (soit 4 fois cette valeur en octet))
    static const int TAILLEWIN = 4;
    static const int TAILLEOFF = 8; // Taille de la fenêtre de window averaging
    static const int TAILLESEARCH=10; // Recherche du min, max avant et après le chgt de signe, sachant que le fréquence d'échantillonage est de 10Hz
    static constexpr float SEUILDETECTION = -0.1;
    static constexpr float SEUILDETECTIONDechets = -1;
    static const int SEUILACCEG = 2; // Je pense que j'ai dû ajouter ce seuil car il y avait une erreur dans SEUILDETECTION car c'est un float
    static const int NBMAXTransmissionS = 3000;
    static const int DUREETransmissionDEFAUT = 10; //durée en secondes mais on peut le modifier avec setDureeTransmission(int) et récupéré par getDureeTransmission
    static const int NBMAXMVT = 9600; // Nombre maximal de mouvements caractérisés(ACTIONS TECHNIQUES) pouvant être gardés en mémoire.

    void setNbDonnees(int lintValue); // Correspond aux nombre de float dans chaque fichier d'enregistrement
    void setNbAxes(int lintAxes, bool lblMontre=0);
    float getAmplitude(int lintAccelerometre);
    float getMean(int lintAccelerometre=0);
    float mean(float* lfltTableau, int lintTailleTableau, int lintDebut, int lintFin);
    float sum(float* lfltTableau, int lintTailleTableau, int lintDebut, int lintFin);
    float min(float* lfltTableau, int lintTailleTableau, int lintDebut, int lintFin); // lintDebut et lintFin sont des valeurs absolues par rapport au début du tableau
    float max(float* lfltTableau, int lintTailleTableau, int lintDebut, int lintFin);
    int maxPos(float* lfltTableau, int lintTailleTableau, int lintDebut, int lintFin);
    int minPos(float* lfltTableau, int lintTailleTableau, int lintDebut, int lintFin);

    //QSqlDatabase mydb = QSqlDatabase::addDatabase("QSQLITE");
    QSqlDatabase mydb = QSqlDatabase::addDatabase("QMYSQL");

    int gintNombreDonnees;
    int gintNombreAxes[WATCHPERAGENT];

    short gshtNbMontres;

    int gIntNbMVT[WATCHPERAGENT]; // nombre de mouvements dans le fichier d'enregistrement reçu
    int gIntNbDechets[WATCHPERAGENT]; // nombre de mouvements dans le fichier d'enregistrement reçu

    int gIntNbTotalMVT[WATCHPERAGENT]; // nombre Total de mvts cumulé depuis l'ouverture du programme
    int gIntNbTotalDechets[WATCHPERAGENT]; // nombre Total de mvts cumulé depuis l'ouverture du programme
    int gTblIntNbMVT[NBMAXTransmissionS][WATCHPERAGENT]; // historique du nb de mvt à chaque fichier

    int gIntDureeEnSecondeTransmission; // Durée en seconde de chaque Transmission d'enregistrement
    int getDureeTransmission();
    int gintNbTotalTransmission; //En nombre de Transmission, ne peut dépasser NBMAXTransmissionS
    int gIntNbSuccesTransmission; // les Transmissions avec lecture réussie de fichiers, pour calculer le temps de travail.
    //void setIntNbSuccesTransmission(int lnb); // Permet de mettre à jour avec une nouvelle valeur

    float gFltRythmeInstantMVT;
    float gFltRythmeMoyenMVT;

    float gfltMinValue[MAXACCFILES][WATCHPERAGENT], gfltMaxValue[MAXACCFILES][WATCHPERAGENT]; // Min et le Max pour chaque accéléromètre (pour tracer les graphiques)
    float gfltAcc[MAXACCFILES][MAXFILESIZE][WATCHPERAGENT]; // valeurs brute de chaque accéléromètre
    float gfltCombinaisonAcc[WATCHPERAGENT][MAXFILESIZE]; // synthèse des différents accéléromètres
    float gfltWindowAverage[MAXFILESIZE];  // synthèse lissée
    bool gbolChangeDirection[MAXFILESIZE]; // détection des changements de direction
    float gfltAmplitude[NBMAXMVT]; //Amplitude de l'action technique détecté dans le tableau de synthèse, place l'information au niveau du gbolChangeDirection =1
    int gintDuree[NBMAXMVT]; //Durée de l'action technique détecté dans le tableau de synthèse, place l'information au niveau du gbolChangeDirection =1

    QDir *filemodel;

    typedef struct Mouvement
    {
        int Transmission;
        int inTransmissionTime;
        float amplitude;
        float duree;
    } Mouvement;

    Mouvement TblMvt[3000];
    // CaracteriseMVT rempli le tableau de Mouvement TblMvt à chaque Transmission
    void CaracteriseMVT(); //Fonction qui à partir de la combinaison des accéléromètres gfltCombinaisonAcc caractérise les mouvements

signals:
    //void totoSignal();

public slots:
    void parseServerMessage(QString strMessage);
};

#endif // GETACCINFO_H
