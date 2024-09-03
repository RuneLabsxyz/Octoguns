impl CharacterIntrospect<> of dojo::model::introspect::Introspect<Character<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(3)
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 1372229579425664236991054426950921761634816755595021216858985086729678017799,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 707101162409551014950475138807685947556878024677686652522286720106255008680,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 801964788416429422283214088413530537011945772225040814883234575189922923682,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'Character',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'entity_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'session_id',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'player_id',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'steps_amount',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct CharacterEntity {
    __id: felt252, // private field
    pub session_id: u32,
    pub player_id: ContractAddress,
    pub steps_amount: u32,
}

#[generate_trait]
pub impl CharacterEntityStoreImpl of CharacterEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> CharacterEntity {
        CharacterModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @CharacterEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<CharacterEntity>::update_entity(self, world);
    }

    fn delete(self: @CharacterEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<CharacterEntity>::delete_entity(self, world);
    }


    fn get_session_id(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            CharacterEntity
        >::get_member(
            world,
            entity_id,
            1372229579425664236991054426950921761634816755595021216858985086729678017799
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Character::session_id`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_session_id(self: @CharacterEntity, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1372229579425664236991054426950921761634816755595021216858985086729678017799,
                serialized.span()
            );
    }

    fn get_player_id(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            CharacterEntity
        >::get_member(
            world,
            entity_id,
            707101162409551014950475138807685947556878024677686652522286720106255008680
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Character::player_id`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_player_id(
        self: @CharacterEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                707101162409551014950475138807685947556878024677686652522286720106255008680,
                serialized.span()
            );
    }

    fn get_steps_amount(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            CharacterEntity
        >::get_member(
            world,
            entity_id,
            801964788416429422283214088413530537011945772225040814883234575189922923682
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Character::steps_amount`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_steps_amount(self: @CharacterEntity, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                801964788416429422283214088413530537011945772225040814883234575189922923682,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl CharacterStoreImpl of CharacterStore {
    fn entity_id_from_keys(entity_id: u32) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@entity_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> Character {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Character>::deserialize(ref serialized);

        if core::option::OptionTrait::<Character>::is_none(@entity) {
            panic!(
                "Model `Character`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Character>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: u32) -> Character {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@entity_id, ref serialized);

        dojo::model::Model::<Character>::get(world, serialized.span())
    }

    fn set(self: @Character, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Character>::set_model(self, world);
    }

    fn delete(self: @Character, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Character>::delete_model(self, world);
    }


    fn get_session_id(world: dojo::world::IWorldDispatcher, entity_id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@entity_id, ref serialized);

        let mut values = dojo::model::Model::<
            Character
        >::get_member(
            world,
            serialized.span(),
            1372229579425664236991054426950921761634816755595021216858985086729678017799
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Character::session_id`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_session_id(self: @Character, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1372229579425664236991054426950921761634816755595021216858985086729678017799,
                serialized.span()
            );
    }

    fn get_player_id(world: dojo::world::IWorldDispatcher, entity_id: u32) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@entity_id, ref serialized);

        let mut values = dojo::model::Model::<
            Character
        >::get_member(
            world,
            serialized.span(),
            707101162409551014950475138807685947556878024677686652522286720106255008680
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Character::player_id`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_player_id(
        self: @Character, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                707101162409551014950475138807685947556878024677686652522286720106255008680,
                serialized.span()
            );
    }

    fn get_steps_amount(world: dojo::world::IWorldDispatcher, entity_id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@entity_id, ref serialized);

        let mut values = dojo::model::Model::<
            Character
        >::get_member(
            world,
            serialized.span(),
            801964788416429422283214088413530537011945772225040814883234575189922923682
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Character::steps_amount`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_steps_amount(self: @Character, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                801964788416429422283214088413530537011945772225040814883234575189922923682,
                serialized.span()
            );
    }
}

pub impl CharacterModelEntityImpl of dojo::model::ModelEntity<CharacterEntity> {
    fn id(self: @CharacterEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @CharacterEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.session_id, ref serialized);
        core::serde::Serde::serialize(self.player_id, ref serialized);
        core::serde::Serde::serialize(self.steps_amount, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> CharacterEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<CharacterEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<CharacterEntity>::is_none(@entity_values) {
            panic!("ModelEntity `CharacterEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<CharacterEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> CharacterEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<Character>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<Character>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @CharacterEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<Character>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Character>::layout()
        );
    }

    fn delete_entity(self: @CharacterEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<Character>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Character>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Character>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<Character>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @CharacterEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Character>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<Character>::selector(),
                    dojo::model::ModelIndex::MemberId((self.id(), member_id)),
                    values,
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }
}

#[cfg(target: "test")]
pub impl CharacterModelEntityTestImpl of dojo::model::ModelEntityTest<CharacterEntity> {
    fn update_test(self: @CharacterEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Character>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Character>::layout()
        );
    }

    fn delete_test(self: @CharacterEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Character>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Character>::layout()
        );
    }
}

pub impl CharacterModelImpl of dojo::model::Model<Character> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> Character {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        CharacterStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @Character, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @Character, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(Self::keys(self)), Self::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, keys: Span<felt252>, member_id: felt252
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(Self::layout(), member_id) {
            Option::Some(field_layout) => {
                let entity_id = dojo::utils::entity_id_from_keys(keys);
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    Self::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @Character,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>
    ) {
        match dojo::utils::find_model_field_layout(Self::layout(), member_id) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    Self::selector(),
                    dojo::model::ModelIndex::MemberId((self.entity_id(), member_id)),
                    values,
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    #[inline(always)]
    fn name() -> ByteArray {
        "Character"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-Character"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        2850333881006672325472846925168884848249989021075085644915780092326858744496
    }

    #[inline(always)]
    fn instance_selector(self: @Character) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        1959542388834788279950687929943693122654840192834537585414959513955547223260
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @Character) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @Character) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.entity_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Character) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.session_id, ref serialized);
        core::serde::Serde::serialize(self.player_id, ref serialized);
        core::serde::Serde::serialize(self.steps_amount, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<Character>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Character) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl CharacterModelTestImpl of dojo::model::ModelTest<Character> {
    fn set_test(self: @Character, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Character>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Character>::keys(self)),
            dojo::model::Model::<Character>::values(self),
            dojo::model::Model::<Character>::layout()
        );
    }

    fn delete_test(self: @Character, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Character>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Character>::keys(self)),
            dojo::model::Model::<Character>::layout()
        );
    }
}

#[starknet::interface]
pub trait Icharacter<T> {
    fn ensure_abi(self: @T, model: Character);
}

#[starknet::contract]
pub mod character {
    use super::Character;
    use super::Icharacter;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Character>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Character>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Character>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<Character>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<Character>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Character>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Character>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<Character>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Character>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<Character>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<Character>::ty()
        }
    }

    #[abi(embed_v0)]
    impl characterImpl of Icharacter<ContractState> {
        fn ensure_abi(self: @ContractState, model: Character) {}
    }
}
