import { writable } from 'svelte/store';
import type { AccountInterface } from 'starknet';

function createPersistentStore<T>(key: string, initialValue: T) {
  const storedValue = localStorage.getItem(key);
  const initial = storedValue ? JSON.parse(storedValue) : initialValue;
  const store = writable<T>(initial);

  store.subscribe(value => {
    localStorage.setItem(key, JSON.stringify(value));
  });

  return store;
}

export const account = createPersistentStore<AccountInterface | undefined>('octoguns_account', undefined);
export const username = createPersistentStore<string | undefined>('octoguns_username', undefined);

export function clearAccountStorage() {
  localStorage.removeItem('octoguns_account');
  localStorage.removeItem('octoguns_username');
  account.set(undefined);
  username.set(undefined);
}