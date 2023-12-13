#include <iostream>
#include <Winsock2.h>
#include <string>
#include <Windows.h>

#pragma comment(lib, "ws2_32.lib")

int main() {
    WSADATA wsaData;
    WSAStartup(MAKEWORD(2, 2), &wsaData);

    SOCKET listenSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

    sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(40000);
    serverAddr.sin_addr.S_un.S_addr = INADDR_ANY;

    bind(listenSocket, (SOCKADDR*)&serverAddr, sizeof(serverAddr));
    listen(listenSocket, SOMAXCONN);

    std::cout << "SERVER STARTED\n";

    while (true) {
        SOCKET clientSocket = accept(listenSocket, NULL, NULL);

        char buffer[100];
        int bytesReceived = recv(clientSocket, buffer, sizeof(buffer), 0);
        if (bytesReceived > 0) {
            std::string message = std::string(buffer, bytesReceived);
            std::cout << "SERVER TAKED: " + message << std::endl;
            message = "ECHO: " + message;
            send(clientSocket, message.c_str(), message.size(), 0);
        }

        closesocket(clientSocket);
    }

    closesocket(listenSocket);
    WSACleanup();

    std::cout << "SERVER CLOSED\n";

    return 0;
}
