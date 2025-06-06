// Description: Get data from an API mocked using MSW
import { expect, test } from 'vitest';

test('responds with the user', async () => {
  const response = await fetch('/api/user');

  await expect(response.json()).resolves.toEqual({
    id: 'abc-123',
    firstName: 'John',
    lastName: 'Maverick'
  });
});
