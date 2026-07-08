class TerminalNative {

public:

virtual bool spawn()=0;

virtual int read(...) =0;

virtual int write(...) =0;

virtual void resize(...) =0;

virtual void close()=0;

};
