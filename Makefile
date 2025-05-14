UNAME_S := $(shell uname -s)

CXXFLAGS ?= -I/usr/include
LDLIBS ?= /usr/lib/x86_64-linux-gnu/libprotobuf.a

ifeq ($(UNAME_S),Linux)
	LDLIBS += -lstdc++fs -pthread
endif

all: ProtoToJson JsonToProto

JsonToProto: ProtoToJson
	ln -f "$<" "$@"

ProtoToJson: ProtobufJson.cc
	g++ -std=c++17 -g -o "$@" ProtobufJson.cc $(CXXFLAGS) $(LDFLAGS) $(LDLIBS)

clean:
	rm -f JsonToProto ProtoToJson

distclean: clean
