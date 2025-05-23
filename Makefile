UNAME_S := $(shell uname -s)

CXXFLAGS += -I/usr/include
ifndef IN_NIX
	LDLIBS += /usr/lib/x86_64-linux-gnu/libprotobuf.a
endif

ifeq ($(UNAME_S),Linux)
	LDLIBS += -lstdc++fs -pthread
endif

all: ProtoToJson JsonToProto

JsonToProto: ProtoToJson
	ln -f "$<" "$@"

ProtoToJson: ProtobufJson.cc
	clang++ -std=c++17 -g -o "$@" ProtobufJson.cc $(CXXFLAGS) $(LDFLAGS) $(LDLIBS)

clean:
	rm -f JsonToProto ProtoToJson

distclean: clean
