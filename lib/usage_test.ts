import {newExample} from './usage';

describe('example', () => {
  it('newExample', () => {
    const ex = newExample('foo', 888);
    expect(ex.getFoo()).toBe('foo');
    expect(ex.getBar()).toBe(888);
  });
});
