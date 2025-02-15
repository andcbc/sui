// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

// tessts various invalid vector instantions for types

//# init --addresses test=0x0 --accounts A B

//# publish
module test::m1 {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct Pub has key, store {
        id: UID,
        value: u64,
    }

    struct Cup<phantom T> has key, store {
        id: UID,
    }

    public fun new(ctx: &mut TxContext): Pub {
        Pub { id: object::new(ctx), value: 112 }
    }

    public fun cup<T>(ctx: &mut TxContext): Cup<T> {
        Cup { id: object::new(ctx) }
    }

    public fun addr(a1: address, cond: bool): address {
        if (cond) a1 else @0x0
    }
}

// simple
//# programmable --sender A --inputs @A
//> 0: test::m1::new();
//> TransferObjects([Result(0)], Input(0));

//# view-object 107

// cast using a Move function
//# programmable --sender A --inputs 0u256
//> 0: sui::address::from_u256(Input(0));
//> 1: test::m1::new();
//> TransferObjects([Result(1)], Result(0));

//# view-object 110

// compilicated Move logic
//# programmable --sender A --inputs @B true
//> 0: sui::address::to_u256(Input(0));
//> 1: sui::address::from_u256(Result(0));
//> 2: test::m1::new();
//> 3: test::m1::addr(Result(1), Input(1));
//> TransferObjects([Result(2)], Result(3));

//# view-object 112

// many object types
//# programmable --sender A --inputs @B true
//> 0: sui::address::to_u256(Input(0));
//> 1: sui::address::from_u256(Result(0));
//> 2: test::m1::new();
//> 3: test::m1::addr(Result(1), Input(1));
//> 4: test::m1::cup<sui::object::ID>();
//> 5: test::m1::cup<test::m1::Pub>();
//> TransferObjects([Result(4), Result(2), Result(5)], Result(3));

//# view-object 114

//# view-object 115

//# view-object 116
