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
#include <QPdfWriter>
#include <QPainter>

#include <QProcess>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>

class getAccInfo : public QObject
{
    Q_OBJECT
public:
    explicit getAccInfo(QObject *parent = nullptr);

    Q_INVOKABLE void autoreadFile(QString qstrMontreGauche, QString qstrMontreDroit);
    Q_INVOKABLE int readSessionFiles(); // lit les fichiers correspondant au timestamp
    Q_INVOKABLE int readAllSessionFiles(); // lit tous les fichiers et les separe en sessions pour remplir la struct FileSessions // https://trello.com/c/QqAHcARc
    Q_INVOKABLE int addSessionFiles(QString lstr1TimeStamp, int lintIndividu, int lintSessiondurationInSec);
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
    Q_INVOKABLE int getAgentId(QString strSerialNo);// a partir de sa montre
    Q_INVOKABLE int getAgentIdFromMessage(QString strMessage); //dans un message

    // SESSION
    Q_INVOKABLE QString getCoreMessage(QString strSerialNo, bool lblOffset);
    Q_INVOKABLE int getAgentStatus(int lintIndex);
    Q_INVOKABLE int getNombreSessions(int lintIndex);
    Q_INVOKABLE QString getSessiondDate(int lintIndividu, int lintIndex);
    Q_INVOKABLE QString getSessionDate(int lintSession);
    Q_INVOKABLE QString getFileSessionDate(int lintIndex);
    Q_INVOKABLE QString getSessionDuration(int lintIndividu, int lintIndex);
    Q_INVOKABLE QString getStrSessionDuration(int lintSession);
    Q_INVOKABLE int getFileSessionDurationInSec(int lintIndex);
    Q_INVOKABLE QString getFileSessionDuration(int lintIndex);
    Q_INVOKABLE int getFileSessionNumber(int lintIndex);
    Q_INVOKABLE QString getFileSessionTimestamp(int lintIndex);
    Q_INVOKABLE int getSessionDuration(int lintSession);  // en minutes
    Q_INVOKABLE int getCurrentSessionDuration(int lintSession); // en secondes
    Q_INVOKABLE int getSessionID(int lintIndividu, int lintIndex);
    Q_INVOKABLE int getSessionNbEnregistrements(int lintSession, bool lblMontreGauche=0);
    Q_INVOKABLE int getSessionNbEnregistrementsMinutes(int lintSession, bool lblMontreGauche=0);
    Q_INVOKABLE int getSessionValueAT(int lintSession, int lintIndex, bool lblMontreGauche=0);
    Q_INVOKABLE int getSessionValueATParMinute(int lintSession, int lintIndex, bool lblMontreGauche=0);
    Q_INVOKABLE int getSessionValueRiskParMinute(int lintSession, int lintIndex, bool lblMontreGauche=0);
    Q_INVOKABLE int getCurrentSessionLastAT(int lintSession, bool lblMontre=0);
    Q_INVOKABLE float getSessionLastRisk(int lintSession, bool lblMontre=0);
    Q_INVOKABLE int getSessionLastObjets(int lintSession, bool lblMontre=0);
    Q_INVOKABLE int getSessionLastCharges(int lintSession, bool lblMontre=0);
    Q_INVOKABLE int getSessionValueOCRA(int lintSession, int lintIndex, bool lblMontreGauche=0);
    Q_INVOKABLE int getSessionValueOCRAParMinute(int lintSession, int lintIndex, bool lblMontreGauche=0);
    Q_INVOKABLE int getSessionValueRisk(int lintSession, int lintIndex, bool lblMontreGauche=0);
    Q_INVOKABLE int getSessionValueObjets(int lintSession, int lintIndex, bool lblMontreGauche=0);
    Q_INVOKABLE int getSessionTotalMVT(int lintSession,bool lblMontreGauche=0);
    Q_INVOKABLE int getSessionTotalObjets(int lintSession);
    Q_INVOKABLE int getSessionTotalCharges(int lintSession);
    Q_INVOKABLE float getSessionMeanRepetitivite(int lintSession, bool lblMontreGauche=0); //repetitivite
    Q_INVOKABLE float getSessionMeanOCRA(int lintSession, bool lblMontreGauche=0); //indice_OCRA
    Q_INVOKABLE float getSessionMeanRisque(int lintSession, bool lblMontreGauche=0);//niveau_risque
    Q_INVOKABLE float getSessionRythmeMoyenMVT(int lintSession,bool lblMontreGauche=0); // en mouvements par minute
    Q_INVOKABLE float getSessionLastRyhtm(int lintSession, bool lblMontre=0); //en mvt par minute
    Q_INVOKABLE int getCurrentSessionId(int lintIndividu);
    Q_INVOKABLE bool deleteSession(int lintSession);

    Q_INVOKABLE bool setSessionMustStart(int lintIndividu);
    Q_INVOKABLE bool setSessionWouldStop(int lintIndividu);
    Q_INVOKABLE bool sendMessage(int lintIndividu, QString strMessage);

    Q_INVOKABLE int getNbDechets(bool lblMontre=0);
    Q_INVOKABLE int getNbDechetsTotal(bool lblMontre=0);

    Q_INVOKABLE int getNbMontres(); // nombre de montres dans la bdd montres (toutes sauf celles recording)
    Q_INVOKABLE QString getNextWatch(); // a chaque appel retourne le serialno d'une montre
    Q_INVOKABLE bool setAgentWatch(int lintIndividu, QString lstrWatchID, bool lblGauche = false); // attribue une montre a un agent

    Q_INVOKABLE bool getWatchStatus(QString lstrSerialNo);

    Q_INVOKABLE QString getAgentNom(QString strMessage);

    //PDF
    Q_INVOKABLE bool generatePDF(int lintSession);

    //Moteur
    Q_INVOKABLE int controlEngine(int lintSpeed);

private:
    static const int MAXACCFILES = 3; // Nombre maximal de fichiers accéléromètres pouvant être utilisés
    static const int WATCHPERAGENT = 2;
    static const int MAXFILESIZE = 1000; // Taille maximale de chaque fichiers accéléromètre (en nombre de float (soit 4 fois cette valeur en octet))
    static const int TAILLEWIN = 4;
    static const int TAILLEOFF = 8; // Taille de la fenêtre de window averaging
    static const int TAILLESEARCH=10; // Recherche du min, max avant et après le chgt de signe, sachant que le fréquence d'échantillonage est de 10Hz
    static constexpr float SEUILDETECTION = -0.01;
    static constexpr float SEUILDETECTIONDechets = -1;
    static const int SEUILACCEG = 2; // Je pense que j'ai dû ajouter ce seuil car il y avait une erreur dans SEUILDETECTION car c'est un float
    static const int NBMAXTransmissionS = 3000;
    static const int DUREETransmissionDEFAUT = 10; //durée en secondes mais on peut le modifier avec setDureeTransmission(int) et récupéré par getDureeTransmission
    static const int NBMAXMVT = 9600; // Nombre maximal de mouvements caractérisés(ACTIONS TECHNIQUES) pouvant être gardés en mémoire.
    const QString UPLOADACCPATH = "/home/eldecog/nodejs/upload/";
    const QString SAVEFOLDER = "PTMS_Saved/";
    static constexpr float OCRADEFAULTRTA = 12;
    static const int MAXFILESESSIONS = 256;

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
    float getOCRA4DBSession(int lintNbAT);
    float getOCRA_RTA();
    void setOcraRta(float lfltOCRA_RTA);
    float getDbNiveauDeRisque(int lintSession,bool lblMontreGauche=0);

    int getAgentIdFromSession(int lintSession);

    unsigned int drawGraphOnPDF(QPainter &painter, unsigned int luintTopGraph, int lintShift = 180, int lintGraphWidth = 8000, int lintGraphHeight = 3000,
                                int xmax=20, int ymax=14, int ymin=0, int xmin=0, QString strLabel1 = "Bras Droit", QString strLabel2 = "Bras Gauche",
                                int lintNumberYLine = 7,int lintNumberXLine = 6, int lintMargin = 25, int lintTextOffset = 100,
                                int lintLegendWidth = 1250, int lintLegendHeight=480, int  lintLegendMargin = 45,int lintLegendInternalMargin = 50,int lintLegendInternalVerticalMargin = 150,
                                int lintLegendLengthTrait = 300, int lintLegendInterline = 200);

    //QSqlDatabase mydb = QSqlDatabase::addDatabase("QSQLITE");
    QSqlDatabase mydb = QSqlDatabase::addDatabase("QMYSQL");

    float gfltOcraRTE;

    int gintNombreDonnees;
    int gintNombreAxes[WATCHPERAGENT];

    short gshtNbMontres;
    int gintCurrentWatchOffset;
    int gintNbTotalWatches;

    int gIntNbMVT[WATCHPERAGENT]; // nombre de mouvements dans le fichier d'enregistrement reçu
    int gIntNbDechets[WATCHPERAGENT]; // nombre de mouvements dans le fichier d'enregistrement reçu

    int gIntNbTotalMVT[WATCHPERAGENT]; // nombre Total de mvts cumulé depuis l'ouverture du programme
    int gIntNbTotalDechets[WATCHPERAGENT]; // nombre Total de mvts cumulé depuis l'ouverture du programme
    int gTblIntNbMVT[NBMAXTransmissionS][WATCHPERAGENT]; // historique du nb de mvt à chaque fichier //HISTORIQUE d'un seul agent !! devrait etre maintenant popule par la BDD pour differents agents

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

    typedef struct FileSessions{ // https://trello.com/c/QqAHcARc
        //FileSessions() {}
        //unsigned char uchrId; // nombre max de session 256 // pas besoin on prend le numero du tableau tblFileSession
        unsigned long ulngTimeStamp; // c'est un timestamp
        unsigned short ushrtDuration;// a priori au max 2560 secondes donc on passe a short pour 65 536
        unsigned char uchrFileNumber; //nombre de fichier max 256
        QString strIDMontre;
    } FileSessions;

    FileSessions tblFileSessions[MAXFILESESSIONS];
    // CaracteriseMVT rempli le tableau de Mouvement TblMvt à chaque Transmission
    void CaracteriseMVT(); //Fonction qui à partir de la combinaison des accéléromètres gfltCombinaisonAcc caractérise les mouvements

signals:
    //void totoSignal();

public slots:
    void parseServerMessage(QString strMessage);
};

#endif // GETACCINFO_H
