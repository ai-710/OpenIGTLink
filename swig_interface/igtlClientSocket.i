%module igtlClientSocket

%{
#include "../Source/igtlClientSocket.h"
%}

%include "typemaps.i"

// Include necessary header files
%include "../Source/igtlSocket.h"
%include "../Source/igtlWin32Header.h"

// Forward declare classes
%{
class ServerSocket;
%}

// Declare namespace
namespace igtl {

// Define the ClientSocket class
class ClientSocket : public Socket {
public:
  // Constructor and Destructor
  ClientSocket();
  ~ClientSocket();

  // Methods
  int ConnectToServer(const char* hostname, int port, bool logErrorIfServerConnectionFailed = true); 
  void PrintSelf(std::ostream& os) const;

  // Macro Definitions
  igtlTypeMacro(igtl::ClientSocket, igtl::Socket)
  igtlNewMacro(igtl::ClientSocket);

private:
  ClientSocket(const ClientSocket&); // Not implemented.
  void operator=(const ClientSocket&); // Not implemented.
};

} // namespace igtl