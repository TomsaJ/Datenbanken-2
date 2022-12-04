
#include "DBSim.h"

/** \brief Versucht beim Start die default.txt zu laden
 */
DBSim::DBSim()
{
    indexTable = nullptr;
    dbTable = nullptr;
    dbEintraege = 0;
    std::ifstream myFile("test.txt");
    if (myFile.is_open())
    {
        loadFile("test.txt");
    }
}

/** \brief Versucht beim Beenden des Programms die momentane Datenbank in die default.txt zu schreiben
 */
DBSim::~DBSim()
{
    try {
        saveFile("test.txt");
    }
    catch (const char* err)
    {
        //fehler ignoriert
    }
}


/** \brief Erstellt die Index-Tabelle
 *
 * \return void
 *
 */
void DBSim::createIndex()
{
    if (dbEintraege < 1) throw "no table to build index from";
    if (indexTable != nullptr)
    {
        delete[] indexTable;
    }
    indexTable = new index[dbEintraege];
    for (int i = 0; i < dbEintraege; i++)
    {
        indexTable[i].position = i;
        std::strcpy(indexTable[i].ordnungsbegriff, dbTable[i].autor);
    }
}

/** \brief gibt den titel f�r die tabelle aus
 *
 * \return void
 *
 */
void printTitle()
{
    std::cout << "|"
        << std::setw(30) << "Autor" << +"|"
        << std::setw(30) << "Titel" << +"|"
        << std::setw(30) << "Verlag" << +"|"
        << std::setw(5) << "Jahr" << +"|"
        << std::setw(30) << "Ort" << +"|"
        << std::setw(30) << "ISBN" << +"|"
        << std::endl;

}

/** \brief gibt eine zeile der tabelle aus
 *
 * \param i int
 * \param dbTable buch*
 * \return void
 *
 */
void DBSim::printLine(int i)
{
    std::cout << "|"
        << std::setw(30) << dbTable[i].autor << +"|"
        << std::setw(30) << dbTable[i].titel << +"|"
        << std::setw(30) << dbTable[i].verlagsname << +"|"
        << std::setw(5) << dbTable[i].erscheinungsjahr << +"|"
        << std::setw(30) << dbTable[i].erscheinungsort << +"|"
        << std::setw(30) << dbTable[i].isbn << +"|"
        << std::endl;
}

void DBSim::hashspeicherung()
{
    for (int i = 0; i < dbEintraege; i++)
    {
        buch ob = { "Alpha", "Beta" };
            //getLineFromTable(indexTable[i].position);
    }
}

/** \brief gibt den inhalt der datenbank aus
 *
 * \return void
 *
 */
void DBSim::print()
{
    printTitle();
    for (int i = 0; i < dbEintraege; i++)
    {
        printLine((noIndex()) ? i : indexTable[i].position);
    }
    std::cout << std::endl;
}

/** \brief Gibt eine Zeile der Datenbanktabelle als string zur�ck
 *
 * \param i int
 * \return std::string
 *
 */
std::string DBSim::getLineFromTable(int i)
{
    if ((i >= dbEintraege) || (i < 0)) throw "index out of bounds";
    return (std::string)dbTable[i].autor + "," + (std::string)dbTable[i].erscheinungsjahr + "," + dbTable[i].erscheinungsort + "," + dbTable[i].isbn + "," + dbTable[i].titel + "," + dbTable[i].verlagsname;
}

/** \brief sucht nach einem author und gibt die ergebnisse aus
 *
 * \param name std::string
 * \return void
 *
 */
void DBSim::searchAuthor(std::string name)
{
    if (indexTable == nullptr) throw "keine Indextabelle vorhanden";
    bool title = false;
    for (int i = 0; i < dbEintraege; i++)
    {
        if (indexTable[i].ordnungsbegriff == name)
        {
            if (!title)
            {
                printTitle();
                title = true;
            }
            printLine(indexTable[i].position);
        }
    }
}


/** \brief schreibt einen string (eine zeile im csv format) in die tabelle
 * wird beim laden einer datei verwendet
 * \param line std::string
 * \param index int
 * \return void
 *
 */
void DBSim::writeStringToTable(std::string line, int index)
{

    if (line.empty()) throw "stringstream is empty";
    if ((index >= dbEintraege) || (index < 0)) throw "writeStringToTable(): index out of bounds";

    std::vector<std::string> values;
    std::string temp;
    std::stringstream os;
    os << line;
    while (std::getline(os, temp, ','))
    {
        values.push_back(temp);
    }
    strcpy(dbTable[index].autor, values[0].c_str());
    //strcpy(dbTable[index].erscheinungsjahr = atoi(values[1].c_str());
    strcpy(dbTable[index].erscheinungsort, values[2].c_str());
    strcpy(dbTable[index].isbn, values[3].c_str());
    strcpy(dbTable[index].titel, values[4].c_str());
    strcpy(dbTable[index].verlagsname, values[5].c_str());

}

/** \brief laedt eine datei
 *
 * \param fileName std::string
 * \return void
 *
 */
void DBSim::loadFile(std::string fileName)
{

    if (fileName.empty()) throw "Dateiname ungueltig";
    std::string str;
    std::vector<std::string> values;
    std::ifstream myFile(fileName);
    if (!myFile.is_open()) throw "Konnte Datei nicht oeffnen";

    while (std::getline(myFile, str))
    {
        values.push_back(str);
    }

    if (dbTable != nullptr)
    {
        delete[] dbTable;
    }
    dbEintraege = values.size();
    dbTable = new buch[dbEintraege];
    for (int i = 0; i < dbEintraege; i++)
    {
        writeStringToTable(values[i], i);
    }
}

/** \brief speichert eine Datei
 *
 * \param fileName std::string
 * \return void
 *
 */
void DBSim::saveFile(std::string fileName)
{
    if (fileName.empty()) throw "saveFile(): Dateiname ungueltig";
    if (dbTable == nullptr) throw "saveFile(): Keine Tabelle zu speichern";
    if (indexTable == nullptr) throw "saveFile(): Zuerst Indextabelle aufbauen";
    std::ofstream myFile(fileName);
    for (int i = 0; i < dbEintraege; i++)
    {
        myFile << getLineFromTable(indexTable[i].position) << std::endl;
    }
}

/** \brief vergleicht den ordnungsbegriff von 2 indizen
 *
 * \param a index
 * \param b index
 * \return bool
 *
 */
bool comparator(index cA, index cB)
{
    std::string sA(cA.ordnungsbegriff), sB(cB.ordnungsbegriff);
    return sA < sB;
}

/** \brief sortiert die index tabelle nach dem ordnungsbegriff
 *
 * \return void
 *
 */
void DBSim::sortIndexArray()
{
    std::sort(indexTable, indexTable + dbEintraege, comparator);
}

/*void DBSim::sortIndexArrayRevers()
{
    std::reverse(indexTable, indexTable + dbEntries, comparator);
}*/

