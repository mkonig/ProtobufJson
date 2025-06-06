UNAME_S := $(shell uname -s)

ifndef IN_NIX
    SHELL := /bin/bash
    CXXFLAGS ?= -Ilib/protobuf-3.21.2/dist/include
    LDLIBS ?= lib/protobuf-3.21.2/dist/lib/libprotobuf.a
endif

ifeq ($(UNAME_S),Linux)
	LDLIBS += -lstdc++fs -pthread
endif

all: ProtoToJson JsonToProto

JsonToProto: ProtoToJson
	ln -f "$<" "$@"

ProtoToJson: ProtobufJson.cc  lib/.compile
	clang++ -std=c++17 -g -o "$@" ProtobufJson.cc $(CXXFLAGS) $(LDFLAGS) $(LDLIBS)

lib/.compile:
ifndef IN_NIX
	./build_dependencies.sh
	touch $@
endif

clean:
	rm -f JsonToProto ProtoToJson

distclean: clean
	rm -rf lib
