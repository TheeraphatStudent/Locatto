import { Tiers } from "../type/reward";

export interface TierConfig {
  code: Tiers;
  name: string;
  description: string;
  revenue: number;
  winner?: string;
}

export interface TierResult {
  [key: string]: string;
}

export const TIER_CONFIGS: { [key: string]: Omit<TierConfig, 'winner'> } = {
  T1: {
    code: 'T1',
    name: 'Tier 1',
    description: 'First prize - Full 6-digit match',
    revenue: 0
  },
  T2: {
    code: 'T2',
    name: 'Tier 2',
    description: 'Second prize - Full 6-digit match',
    revenue: 0
  },
  T3: {
    code: 'T3',
    name: 'Tier 3',
    description: 'Third prize - Full 6-digit match',
    revenue: 0
  },
  T1L3: {
    code: 'T1L3',
    name: 'Tier 1 Last 3',
    description: 'Last 3 digits of Tier 1 winner',
    revenue: 0
  },
  R2: {
    code: 'R2',
    name: 'Random 2 Digits',
    description: 'Random 2-digit number (10-99)',
    revenue: 0
  }
};


export const getAllTierConfigs = (): TierConfig[] => {
  return Object.values(TIER_CONFIGS).map(config => ({
    ...config,
    winner: undefined
  }));
};


export const getTierConfig = (code: string): TierConfig | null => {
  const config = TIER_CONFIGS[code];
  return config ? { ...config, winner: undefined } : null;
};


export const isValidTierCode = (code: string): boolean => {
  return code in TIER_CONFIGS;
};

export const getWinnerTierCodes = (): string[] => {
  return ['T1', 'T2', 'T3'];
};


export const getDerivedTierCodes = (): string[] => {
  return ['T1L3', 'R2'];
};

export const getAllTierCodes = (): string[] => {
  return Object.keys(TIER_CONFIGS);
};


export const generateDerivedTiers = (winners: TierResult): TierResult => {
  const derived: TierResult = {};

  if (winners.tier1) {
    derived.tier4 = winners.tier1.slice(-3);
  }

  derived.tier5 = Math.floor(Math.random() * 90 + 10).toString();

  return derived;
};

export const validateTierResult = (result: TierResult): { valid: boolean; errors: string[] } => {
  const errors: string[] = [];
  const requiredTiers = ['tier1', 'tier2', 'tier3', 'tier4', 'tier5'];

  for (const tier of requiredTiers) {
    if (!result[tier]) {
      errors.push(`Missing ${tier}`);
    }
  }

  if (result.tier1 && !/^\d{6}$/.test(result.tier1)) {
    errors.push('Tier 1 must be 6 digits');
  }
  if (result.tier2 && !/^\d{6}$/.test(result.tier2)) {
    errors.push('Tier 2 must be 6 digits');
  }
  if (result.tier3 && !/^\d{6}$/.test(result.tier3)) {
    errors.push('Tier 3 must be 6 digits');
  }
  if (result.tier4 && !/^\d{3}$/.test(result.tier4)) {
    errors.push('Tier 4 must be 3 digits');
  }
  if (result.tier5 && !/^\d{2}$/.test(result.tier5)) {
    errors.push('Tier 5 must be 2 digits');
  }

  return {
    valid: errors.length === 0,
    errors
  };
};

export const formatTierResult = (result: TierResult): any => {
  return {
    T1: result.tier1,
    T2: result.tier2,
    T3: result.tier3,
    T1L3: result.tier4,
    R2: result.tier5
  };
};
