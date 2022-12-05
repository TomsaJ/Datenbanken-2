#pragma warning(disable : 4996)
#include "DBSim.h"
#include <algorithm>

/** \brief Versucht beim Start die default.txt zu laden
 */
DBSim::DBSim()
{
    indexTable = nullptr;
    blockarray = new block[36];
    for (int i = 0; i < 36; i++)
    {
        blockarray[i].n = 0;
        blockarray[i].overflowBlock = nullptr;
    }
    dbEntries = 0;
    std::ifstream myFile("default.txt");
    if (myFile.is_open())
    {
        loadFile("default.txt");
    }
}

block* newBlock()
{
    block* temp = new block;
    temp->n = 0;
    temp->overflowBlock = nullptr;
    return temp;
}

void DBSim::clearOFBlocks(struct block* toClear)
{
    if (toClear->overflowBlock != nullptr)
    {
        clearOFBlocks(toClear->overflowBlock);
    }
    else
    {
        delete toClear;
    }
}

void DBSim::clearTable()
{
    for (int i = 0; i < 36; i++)
    {
        if (blockarray[i].overflowBlock != nullptr)
        {
            clearOFBlocks(blockarray[i].overflowBlock);
        }
        blockarray[i].overflowBlock = nullptr;
        blockarray[i].n = 0;
        dbEntries = 0;
    }
}

/** \brief Versucht beim Beenden des Programms die momentane Datenbank in die default.txt zu schreiben
 */
DBSim::~DBSim()
{
    try {
        saveFile("default.txt");
    }
    catch (const char* err)
    {
        std::cout << err;
    }
    clearTable();
    delete[] blockarray;
}

int DBSim::getHash(int key)
{
    int result = 0;
    int temp = key;
    while (temp > 0)
    {
        result += temp % 10;
        temp /= 10;
    }
    return result;
}

/** \brief Erstellt die Index-Tabelle
 *
 * \return void
 *
 */
void DBSim::createIndex()
{
    if (dbEntries < 1) throw "createIndex(): no table to build index from";
    if (indexTable != nullptr)
    {
        delete[] indexTable;
    }
    indexTable = new index[dbEntries];
    int counter = 0;
    block* curr;
    for (int i = 0; i < 36; i++)
    {
        curr = &blockarray[i];
        while (curr != nullptr)
        {
            for (int j = 0; j < curr->n; j++)
            {
                //                std::string temp(curr->data[j].autor);
                //                std::cout << ((indexTable[counter].address == nullptr) ? "nullptr " : "valid ptr ") << getHash(counter+1) << " " << j << " " << temp << std::endl;
                indexTable[counter].address = curr;
                indexTable[counter].position = j;
                strcpy(indexTable[counter].ordnungsbegriff, curr->data[j].autor);
                counter++;
            }
            curr = curr->overflowBlock;
        }
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
void DBSim::printLine(block* block, int pos)
{
    if (block == nullptr)
        throw "printLine() block is null";
    if (pos < 0 || pos > 5)
        throw "pos out of bounds";
    std::cout << "|"
        << std::setw(30) << block->data[pos].autor << +"|"
        << std::setw(30) << block->data[pos].titel << +"|"
        << std::setw(30) << block->data[pos].verlagsname << +"|"
        << std::setw(5) << block->data[pos].erscheinungsjahr << +"|"
        << std::setw(30) << block->data[pos].erscheinungsort << +"|"
        << std::setw(30) << block->data[pos].isbn << +"|"
        << std::endl;
}

/** \brief gibt den inhalt der datenbank aus
 *
 * \return void
 *
 */
void DBSim::print()
{
    printTitle();
    if (noIndex())
    {
        bool done;
        block* curr;
        int counter = 0;
        for (int i = 0; i < 36; i++)
        {
            done = false;
            curr = &blockarray[i];
            while (done == false)
            {
                for (int j = 0; j < curr->n; j++)
                {
                    printLine(curr, j);
                }
                if (curr->overflowBlock == nullptr)
                {
                    done = true;
                }
                else
                {
                    curr = curr->overflowBlock;
                }
            }
        }
    }
    else
    {
        for (int i = 0; i < dbEntries; i++)
        {
            printLine(indexTable[i].address, indexTable[i].position);
        }
    }
    std::cout << std::endl;
}

/** \brief Gibt eine Zeile der Datenbanktabelle als string zur�ck
 *
 * \param i int
 * \return std::string
 *
 */
std::string DBSim::getLineFromTable(block* block, int pos)
{
    if (block == nullptr) throw "getLineFromTable(): block index out of bounds";
    if ((pos >= 5) || (pos < 0)) throw "getLineFromTable(): position index out of bounds";
    return (std::string)block->data[pos].autor + "," +
        std::to_string(block->data[pos].erscheinungsjahr) + "," +
        block->data[pos].erscheinungsort + "," +
        block->data[pos].isbn + "," +
        block->data[pos].titel + "," +
        block->data[pos].verlagsname;
}

/** \brief sucht nach einem author und gibt die ergebnisse aus
 *
 * \param name std::string
 * \return void
 *
 */
void DBSim::searchAuthor(std::string name)
{
    if (indexTable == nullptr) throw "searchAuthor(): keine Indextabelle vorhanden";
    bool title = false;
    for (int i = 0; i < dbEntries; i++)
    {
        if (indexTable[i].ordnungsbegriff == name)
        {
            if (!title)
            {
                printTitle();
                title = true;
            }
            printLine(indexTable[i].address, indexTable[i].position);
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
void DBSim::writeStringToTable(std::string line)
{

    if (line.empty()) throw "writeStringToTable(): string is empty";

    std::vector<std::string> values;
    std::string temp;
    int hash = getHash(dbEntries + 1) - 1;

    //kannte keine �quivalente L�sung f�r strings
    std::stringstream os;
    os << line;
    while (std::getline(os, temp, ','))
    {
        values.push_back(temp);
    }

    block* curr = &blockarray[hash];

    while (curr->n == 5)
    {
        if (curr->overflowBlock == nullptr)
        {
            curr->overflowBlock = newBlock();
        }
        curr = curr->overflowBlock;
    }

    strcpy(curr->data[curr->n].autor, values[0].c_str());
    curr->data[curr->n].erscheinungsjahr = atoi(values[1].c_str());
    strcpy(curr->data[curr->n].erscheinungsort, values[2].c_str());
    strcpy(curr->data[curr->n].isbn, values[3].c_str());
    strcpy(curr->data[curr->n].titel, values[4].c_str());
    strcpy(curr->data[curr->n].verlagsname, values[5].c_str());
    curr->data[curr->n].key = dbEntries + 1;
    dbEntries++;
    curr->n++;
}

/** \brief l�dt eine csv datei
 *
 * \param fileName std::string
 * \return void
 *
 */
void DBSim::loadFile(std::string fileName)
{
    if (fileName.empty()) throw "loadFile(): Dateiname ungueltig";
    std::string str;
    std::vector<std::string> values;
    std::ifstream myFile(fileName);
    if (!myFile.is_open()) throw "Konnte Datei nicht oeffnen";

    clearTable();

    while (std::getline(myFile, str))
    {
        writeStringToTable(str);
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
    if (blockarray == nullptr) throw "saveFile(): Keine Tabelle zu speichern";
    if (indexTable == nullptr) throw "saveFile(): Zuerst Indextabelle aufbauen";
    std::ofstream myFile(fileName);
    std::cout << "DB Entries: " << dbEntries << std::endl;
    for (int i = 0; i < dbEntries; i++)
    {
        myFile << getLineFromTable(indexTable[i].address, indexTable[i].position) << std::endl;
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
    if (noIndex())
        throw "sortIndexArray(): kein Indexarray vorhanden";
    std::sort(indexTable, indexTable + dbEntries, comparator);
}
// Funktion schreib einen Datensatz in das datenArray
void DBSim::datensatzInDatenarray(string line)
{
    if (line.empty())
        throw "datensatzInDatenarray: uebergebener String ist leer";


    vector<string> werte;
    string temp;
    int hash = hashBerechnen(dbEntries + 1) - 1;

    stringstream os;
    os << line;
    //stringstream am Komma trennen und auf dem Vector speichern
    while (getline(os, temp, ','))
    {
        werte.push_back(temp);
    }

    block* curr = &blockarray[hash];

    while (curr->n == 5)
    {
        if (curr->overflowBlock == nullptr)
        {
            curr->overflowBlock = newBlock();
        }
        curr = curr->overflowBlock;
    }

    strcpy(curr->data[curr->n].autor, werte[0].c_str());
    strcpy(curr->data[curr->n].titel, werte[1].c_str());
    strcpy(curr->data[curr->n].verlagsname, werte[2].c_str());
    curr->data[curr->n].erscheinungsjahr = atoi(werte[3].c_str());
    strcpy(curr->data[curr->n].erscheinungsort, werte[4].c_str());
    strcpy(curr->data[curr->n].isbn, werte[5].c_str());
    curr->data[curr->n].key = dbEntries + 1;
    dbEntries++;
    curr->n++;
}

void DBSim::sucheKey(int key) {
    int hash = hashBerechnen(key) - 1;

    cout << "Ich suche in Block: " << hash + 1 << endl;

    block* curr = &blockarray[hash];

    int i = 0;
    while (curr->data[i].key != key && i < curr->n) {
        i++;
        if (i == 5 && curr->overflowBlock != nullptr)
        {
            curr = curr->overflowBlock;
            i = 0;
        }
           
    }
    ausgabeDaten(curr, i);
}

int DBSim::hashBerechnen(int n)
{
    int quer = 0;
    int zahl = n;
    while (zahl > 0)
    {
        quer += zahl % 10;
        zahl /= 10;
    }
    return quer;
}

// Ausgabe der Tabellenueberschrift
void DBSim::ausgabeTitel()
{
    cout << "|" << setw(15) << "Autor" << +"|" << setw(30) << "Titel" << +"|"
        << setw(20) << "Verlag" << +"|" << setw(5) << "Jahr" << +"|"
        << setw(15) << "Ort" << +"|" << setw(15) << "ISBN" << +"|" << endl;
}

// Funktion gibt einen Datensatz aus
void DBSim::ausgabeDaten(block* curr, int n)
{
    cout << "|" << setw(15) << curr->data[n].autor << +"|" << setw(30) << curr->data[n].titel << +"|"
        << setw(20) << curr->data[n].verlagsname << +"|" << setw(5) << curr->data[n].erscheinungsjahr << +"|"
        << setw(15) << curr->data[n].erscheinungsort << +"|" << setw(15) << curr->data[n].isbn << +"|" << endl;
}


void DBSim::printStructure()
{
    block* curr;
    for (int i = 0; i < 36; i++)
    {
        curr = &blockarray[i];
        std::cout << std::setw(2) << i + 1 << ": " << "[" << curr->n << "]";
        while (curr->overflowBlock != nullptr)
        {
            curr = curr->overflowBlock;
            std::cout << " - [" << curr->n << "]";
        }
        std::cout << std::endl;
    }
}
