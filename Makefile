#
# Makefile for NetImgui Server - Linux GLFW/OpenGL3
#
# Dependencies:
#   apt-get install libglfw-dev libgl-dev
#

EXE = netimgui_server

NETIMGUI_DIR    = .
SERVERAPP_DIR   = $(NETIMGUI_DIR)/Code/ServerApp/Source
GLFWGL3_DIR     = $(SERVERAPP_DIR)/GlfwGL3
CLIENT_DIR      = $(NETIMGUI_DIR)/Code/Client/Private
IMGUI_DIR       = $(NETIMGUI_DIR)/Code/ThirdParty/DearImgui
THIRDPARTY_DIR  = $(NETIMGUI_DIR)/Code/ThirdParty

SOURCES  =
# Platform entry point + HAL (GlfwGL3)
SOURCES += $(GLFWGL3_DIR)/NetImguiServer_App_GlfwGL3.cpp
SOURCES += $(GLFWGL3_DIR)/NetImguiServer_HAL_Glfw.cpp
SOURCES += $(GLFWGL3_DIR)/NetImguiServer_HAL_GL3.cpp
# Core server app
SOURCES += $(SERVERAPP_DIR)/NetImguiServer_App.cpp
SOURCES += $(SERVERAPP_DIR)/NetImguiServer_Config.cpp
SOURCES += $(SERVERAPP_DIR)/NetImguiServer_Network.cpp
SOURCES += $(SERVERAPP_DIR)/NetImguiServer_RemoteClient.cpp
SOURCES += $(SERVERAPP_DIR)/NetImguiServer_UI.cpp
SOURCES += $(SERVERAPP_DIR)/Custom/NetImguiServer_App_Custom.cpp
# NetImgui client library
SOURCES += $(CLIENT_DIR)/NetImgui_Api.cpp
SOURCES += $(CLIENT_DIR)/NetImgui_Client.cpp
SOURCES += $(CLIENT_DIR)/NetImgui_CmdPackets_DrawFrame.cpp
SOURCES += $(CLIENT_DIR)/NetImgui_NetworkPosix.cpp
# Dear ImGui (imgui_impl_glfw/opengl3 are #included directly by GlfwGL3.cpp)
SOURCES += $(IMGUI_DIR)/imgui.cpp
SOURCES += $(IMGUI_DIR)/imgui_demo.cpp
SOURCES += $(IMGUI_DIR)/imgui_draw.cpp
SOURCES += $(IMGUI_DIR)/imgui_tables.cpp
SOURCES += $(IMGUI_DIR)/imgui_widgets.cpp
# ThirdParty
SOURCES += $(THIRDPARTY_DIR)/quicklz.cpp

OBJS = $(addsuffix .o, $(basename $(notdir $(SOURCES))))

CXXFLAGS  = -std=c++17
CXXFLAGS += -I$(NETIMGUI_DIR)/Code/Client
CXXFLAGS += -I$(NETIMGUI_DIR)/Code/ServerApp/Source
CXXFLAGS += -I$(NETIMGUI_DIR)/Code/ThirdParty/DearImgui
CXXFLAGS += -I$(NETIMGUI_DIR)/Code/ThirdParty/DearImgui/backends
CXXFLAGS += -I$(NETIMGUI_DIR)/Code
CXXFLAGS += -I$(NETIMGUI_DIR)/Code/ThirdParty
CXXFLAGS += -g -Wall -Wformat
CXXFLAGS += `pkg-config --cflags glfw3`

LIBS  = -lGL
LIBS += `pkg-config --static --libs glfw3`
LIBS += -lpthread

##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------

%.o: $(GLFWGL3_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o: $(SERVERAPP_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o: $(SERVERAPP_DIR)/Custom/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o: $(CLIENT_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o: $(IMGUI_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

%.o: $(THIRDPARTY_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

all: $(EXE)
	@echo "Build complete."

$(EXE): $(OBJS)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LIBS)

clean:
	rm -f $(EXE) $(OBJS)
