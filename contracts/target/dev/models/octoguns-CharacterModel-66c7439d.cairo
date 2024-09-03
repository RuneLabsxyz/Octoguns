impl CharacterModelIntrospect<> of dojo::model::introspect::Introspect<CharacterModel<>> {
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
                name: 'CharacterModel',
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
pub struct CharacterModelEntity {
    __id: felt252, // private field
    pub session_id: u32,
    pub player_id: ContractAddress,
    pub steps_amount: u32,
}

#[generate_trait]
pub impl CharacterModelEntityStoreImpl of CharacterModelEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> CharacterModelEntity {
        CharacterModelModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @CharacterModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<CharacterModelEntity>::update_entity(self, world);
    }

    fn delete(self: @CharacterModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<CharacterModelEntity>::delete_entity(self, world);
    }


    fn get_session_id(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            CharacterModelEntity
        >::get_member(
            world,
            entity_id,
            1372229579425664236991054426950921761634816755595021216858985086729678017799
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `CharacterModel::session_id`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_session_id(
        self: @CharacterModelEntity, world: dojo::world::IWorldDispatcher, value: u32
    ) {
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
            CharacterModelEntity
        >::get_member(
            world,
            entity_id,
            707101162409551014950475138807685947556878024677686652522286720106255008680
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `CharacterModel::player_id`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_player_id(
        self: @CharacterModelEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
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
            CharacterModelEntity
        >::get_member(
            world,
            entity_id,
            801964788416429422283214088413530537011945772225040814883234575189922923682
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `CharacterModel::steps_amount`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_steps_amount(
        self: @CharacterModelEntity, world: dojo::world::IWorldDispatcher, value: u32
    ) {
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
pub impl CharacterModelStoreImpl of CharacterModelStore {
    fn entity_id_from_keys(entity_id: u32) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@entity_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> CharacterModel {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<CharacterModel>::deserialize(ref serialized);

        if core::option::OptionTrait::<CharacterModel>::is_none(@entity) {
            panic!(
                "Model `CharacterModel`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<CharacterModel>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: u32) -> CharacterModel {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@entity_id, ref serialized);

        dojo::model::Model::<CharacterModel>::get(world, serialized.span())
    }

    fn set(self: @CharacterModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<CharacterModel>::set_model(self, world);
    }

    fn delete(self: @CharacterModel, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<CharacterModel>::delete_model(self, world);
    }


    fn get_session_id(world: dojo::world::IWorldDispatcher, entity_id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@entity_id, ref serialized);

        let mut values = dojo::model::Model::<
            CharacterModel
        >::get_member(
            world,
            serialized.span(),
            1372229579425664236991054426950921761634816755595021216858985086729678017799
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `CharacterModel::session_id`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_session_id(self: @CharacterModel, world: dojo::world::IWorldDispatcher, value: u32) {
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
            CharacterModel
        >::get_member(
            world,
            serialized.span(),
            707101162409551014950475138807685947556878024677686652522286720106255008680
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `CharacterModel::player_id`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_player_id(
        self: @CharacterModel, world: dojo::world::IWorldDispatcher, value: ContractAddress
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
            CharacterModel
        >::get_member(
            world,
            serialized.span(),
            801964788416429422283214088413530537011945772225040814883234575189922923682
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `CharacterModel::steps_amount`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_steps_amount(self: @CharacterModel, world: dojo::world::IWorldDispatcher, value: u32) {
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

pub impl CharacterModelModelEntityImpl of dojo::model::ModelEntity<CharacterModelEntity> {
    fn id(self: @CharacterModelEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @CharacterModelEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.session_id, ref serialized);
        core::serde::Serde::serialize(self.player_id, ref serialized);
        core::serde::Serde::serialize(self.steps_amount, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> CharacterModelEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<CharacterModelEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<CharacterModelEntity>::is_none(@entity_values) {
            panic!("ModelEntity `CharacterModelEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<CharacterModelEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> CharacterModelEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<CharacterModel>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<CharacterModel>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @CharacterModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<CharacterModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<CharacterModel>::layout()
        );
    }

    fn delete_entity(self: @CharacterModelEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<CharacterModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<CharacterModel>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<CharacterModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<CharacterModel>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @CharacterModelEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<CharacterModel>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<CharacterModel>::selector(),
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
pub impl CharacterModelModelEntityTestImpl of dojo::model::ModelEntityTest<CharacterModelEntity> {
    fn update_test(self: @CharacterModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<CharacterModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<CharacterModel>::layout()
        );
    }

    fn delete_test(self: @CharacterModelEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<CharacterModel>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<CharacterModel>::layout()
        );
    }
}

pub impl CharacterModelModelImpl of dojo::model::Model<CharacterModel> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> CharacterModel {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        CharacterModelStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @CharacterModel, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @CharacterModel, world: dojo::world::IWorldDispatcher) {
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
        self: @CharacterModel,
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
        "CharacterModel"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-CharacterModel"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        2905498737023562515064075557911130664473064044981887349158677167747889380356
    }

    #[inline(always)]
    fn instance_selector(self: @CharacterModel) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        2926354648464384786620429334632956880737663386053143331340611619326458993167
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @CharacterModel) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @CharacterModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.entity_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @CharacterModel) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.session_id, ref serialized);
        core::serde::Serde::serialize(self.player_id, ref serialized);
        core::serde::Serde::serialize(self.steps_amount, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<CharacterModel>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @CharacterModel) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl CharacterModelModelTestImpl of dojo::model::ModelTest<CharacterModel> {
    fn set_test(self: @CharacterModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<CharacterModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<CharacterModel>::keys(self)),
            dojo::model::Model::<CharacterModel>::values(self),
            dojo::model::Model::<CharacterModel>::layout()
        );
    }

    fn delete_test(self: @CharacterModel, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<CharacterModel>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<CharacterModel>::keys(self)),
            dojo::model::Model::<CharacterModel>::layout()
        );
    }
}

#[starknet::interface]
pub trait Icharacter_model<T> {
    fn ensure_abi(self: @T, model: CharacterModel);
}

#[starknet::contract]
pub mod character_model {
    use super::CharacterModel;
    use super::Icharacter_model;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<CharacterModel>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<CharacterModel>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<CharacterModel>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<CharacterModel>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<CharacterModel>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<CharacterModel>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<CharacterModel>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<CharacterModel>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<CharacterModel>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<CharacterModel>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<CharacterModel>::ty()
        }
    }

    #[abi(embed_v0)]
    impl character_modelImpl of Icharacter_model<ContractState> {
        fn ensure_abi(self: @ContractState, model: CharacterModel) {}
    }
}
