extension HubConnection {
    public func on(methodName: String, handler: @escaping () async -> Void) throws {
        self.on(method: methodName, types: [],  handler: { _ in
            await handler()
        })
    }

    public func on<T>(methodName: String, handler: @escaping (T) async -> Void) throws {
        self.on(method: methodName, types: [T.self], handler: { args in
            guard let arg = args.first as? T else {
                throw SignalRError.invalidOperation("Failed to convert arguments to type \(T.self)")
            }
            await handler(arg)
        })
    }

    public func on<T1, T2>(methodName: String, handler: @escaping (T1, T2) async -> Void) throws {
        self.on(method: methodName, types: [T1.self, T2.self], handler: { args in
            guard let arg1 = args.first as? T1, let arg2 = args.last as? T2 else {
                throw SignalRError.invalidOperation("Failed to convert arguments to type \(T1.self), \(T2.self)")
            }
            await handler(arg1, arg2)
        })
    }

    public func on<T1, T2, T3>(methodName: String, handler: @escaping (T1, T2, T3) async -> Void) throws {
        self.on(method: methodName, types: [T1.self, T2.self, T3.self], handler: { args in
            guard let arg1 = args[0] as? T1, let arg2 = args[1] as? T2, let arg3 = args[2] as? T3 else {
                throw SignalRError.invalidOperation("Failed to convert arguments to type \(T1.self), \(T2.self), \(T3.self)")
            }
            await handler(arg1, arg2, arg3)
        })
    }

    public func on<T1, T2, T3, T4>(methodName: String, handler: @escaping (T1, T2, T3, T4) async -> Void) throws {
        self.on(method: methodName, types: [T1.self, T2.self, T3.self, T4.self], handler: { args in
            guard let arg1 = args[0] as? T1, let arg2 = args[1] as? T2, let arg3 = args[2] as? T3, let arg4 = args[3] as? T4 else {
                throw SignalRError.invalidOperation("Failed to convert arguments to type \(T1.self), \(T2.self), \(T3.self), \(T4.self)")
            }
            await handler(arg1, arg2, arg3, arg4)
        })
    }

    public func on<T1, T2, T3, T4, T5>(methodName: String, handler: @escaping (T1, T2, T3, T4, T5) async -> Void) throws {
        self.on(method: methodName, types: [T1.self, T2.self, T3.self, T4.self, T5.self], handler: { args in
            guard let arg1 = args[0] as? T1, let arg2 = args[1] as? T2, let arg3 = args[2] as? T3, let arg4 = args[3] as? T4, let arg5 = args[4] as? T5 else {
                throw SignalRError.invalidOperation("Failed to convert arguments to type \(T1.self), \(T2.self), \(T3.self), \(T4.self), \(T5.self)")
            }
            await handler(arg1, arg2, arg3, arg4, arg5)
        })
    }

    public func on<T1, T2, T3, T4, T5, T6>(methodName: String, handler: @escaping (T1, T2, T3, T4, T5, T6) async -> Void) throws {
        self.on(method: methodName, types: [T1.self, T2.self, T3.self, T4.self, T5.self, T6.self], handler: { args in
            guard let arg1 = args[0] as? T1, let arg2 = args[1] as? T2, let arg3 = args[2] as? T3, let arg4 = args[3] as? T4, let arg5 = args[4] as? T5, let arg6 = args[5] as? T6 else {
                throw SignalRError.invalidOperation("Failed to convert arguments to type \(T1.self), \(T2.self), \(T3.self), \(T4.self), \(T5.self), \(T6.self)")
            }
            await handler(arg1, arg2, arg3, arg4, arg5, arg6)
        })
    }

    public func on<T1, T2, T3, T4, T5, T6, T7>(methodName: String, handler: @escaping (T1, T2, T3, T4, T5, T6, T7) async -> Void) throws {
        self.on(method: methodName, types: [T1.self, T2.self, T3.self, T4.self, T5.self, T6.self, T7.self], handler: { args in
            guard let arg1 = args[0] as? T1, let arg2 = args[1] as? T2, let arg3 = args[2] as? T3, let arg4 = args[3] as? T4, let arg5 = args[4] as? T5, let arg6 = args[5] as? T6, let arg7 = args[6] as? T7 else {
                throw SignalRError.invalidOperation("Failed to convert arguments to type \(T1.self), \(T2.self), \(T3.self), \(T4.self), \(T5.self), \(T6.self), \(T7.self)")
            }
            await handler(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
        })
    }

    public func on<T1, T2, T3, T4, T5, T6, T7, T8>(methodName: String, handler: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) async -> Void) throws {
        self.on(method: methodName, types: [T1.self, T2.self, T3.self, T4.self, T5.self, T6.self, T7.self, T8.self], handler: { args in
            guard let arg1 = args[0] as? T1, let arg2 = args[1] as? T2, let arg3 = args[2] as? T3, let arg4 = args[3] as? T4, let arg5 = args[4] as? T5, let arg6 = args[5] as? T6, let arg7 = args[6] as? T7, let arg8 = args[7] as? T8 else {
                throw SignalRError.invalidOperation("Failed to convert arguments to type \(T1.self), \(T2.self), \(T3.self), \(T4.self), \(T5.self), \(T6.self), \(T7.self), \(T8.self)")
            }
            await handler(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
        })
    }

    public func on<T1, T2, T3, T4, T5, T6, T7, T8, T9>(methodName: String, handler: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) async -> Void) throws {
        self.on(method: methodName, types: [T1.self, T2.self, T3.self, T4.self, T5.self, T6.self, T7.self, T8.self, T9.self], handler: { args in
            guard let arg1 = args[0] as? T1, let arg2 = args[1] as? T2, let arg3 = args[2] as? T3, let arg4 = args[3] as? T4, let arg5 = args[4] as? T5, let arg6 = args[5] as? T6, let arg7 = args[6] as? T7, let arg8 = args[7] as? T8, let arg9 = args[8] as? T9 else {
                throw SignalRError.invalidOperation("Failed to convert arguments to type \(T1.self), \(T2.self), \(T3.self), \(T4.self), \(T5.self), \(T6.self), \(T7.self), \(T8.self), \(T9.self)")
            }
            await handler(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
        })
    }
}